#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

// Tastatur-Mapping (angepasst für ZX80)
const uint8_t key_map[8][5] = {
    { '1', '2', '3', '4', '5' },          // Row 0
    { '6', '7', '8', '9', '0' },          // Row 1
    { 'Q', 'W', 'E', 'R', 'T' },          // Row 2
    { 'Y', 'U', 'I', 'O', 'P' },          // Row 3
    { 'A', 'S', 'D', 'F', 'G' },          // Row 4
    { 'H', 'J', 'K', 'L', '\n' },         // Row 5 (NEW LINE = '\n')
    { 'Z', 'X', 'C', 'V', 'B' },          // Row 6
    { ' ', '^', '.', '\r', '\b' }         // Row 7 (SPACE, SHIFT = '^', ENTER = '\r', BACKSPACE = '\b')
};

// UART initialisieren
void uart_init(uint16_t baudrate) {
    uint16_t ubrr = F_CPU / 16 / baudrate - 1;
    UBRRH = (uint8_t)(ubrr >> 8);
    UBRRL = (uint8_t)ubrr;
    UCSRB = (1 << TXEN); // UART-Sender aktivieren
    UCSRC = (1 << URSEL) | (3 << UCSZ0); // 8 Datenbits, 1 Stoppbit
}

// Hex-Code über UART senden
void uart_send(uint8_t data) {
    while (!(UCSRA & (1 << UDRE))); // Warten, bis der Sendepuffer frei ist
    UDR = data;
}

// Tastencode senden
void send_key_hex(uint8_t key) {
    uart_send(key);
}

// Variablen für Interrupts
volatile uint8_t active_row = 0;
volatile uint8_t key_pressed = 0;

// Interrupt Service Routine (Timer)
ISR(TIMER0_OVF_vect) {
    static uint8_t row = 0;
    
    // Alle Spalten auf Eingang mit Pull-up setzen
    DDRC = 0x00;
    PORTC = 0xFF;

    // Aktuelle Reihe aktivieren
    DDRD = (1 << row);
    PORTD = ~(1 << row);

    // Spalten auslesen
    uint8_t col = ~PINC & 0x1F; // Nur die unteren 5 Bits

    // Wenn eine Taste gedrückt ist, verarbeiten
    if (col) {
        for (uint8_t c = 0; c < 5; c++) {
            if (col & (1 << c)) {
                key_pressed = key_map[row][c];
                break;
            }
        }
    }

    // Zur nächsten Reihe wechseln
    row = (row + 1) % 8;
    active_row = row;
}

// Tastatur auslesen und Hex-Code senden
void read_keyboard_and_send() {
    static uint8_t shift_active = 0;

    if (key_pressed) {
        if (key_pressed == '^') { // SHIFT erkannt
            shift_active = 1;
        } else {
            if (shift_active) {
                // Großbuchstaben oder Sonderzeichen dekodieren
                if (key_pressed >= 'a' && key_pressed <= 'z') {
                    key_pressed -= 32; // Klein- zu Großbuchstaben
                }
                // Füge hier Sonderzeichendekodierung hinzu (z. B. '1' -> '!').
                shift_active = 0;
            }
            send_key_hex(key_pressed);
        }
        key_pressed = 0;
    }
}

// Timer konfigurieren
void timer_init() {
    TCCR0 = (1 << CS01) | (1 << CS00); // Prescaler 64
    TIMSK = (1 << TOIE0); // Overflow-Interrupt aktivieren
    sei(); // Globale Interrupts aktivieren
}

int main(void) {
    uart_init(9600); // UART mit 9600 Baud initialisieren
    timer_init();    // Timer für Tastatur-Scanning konfigurieren

    while (1) {
        read_keyboard_and_send();
    }
}

