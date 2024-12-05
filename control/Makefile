# Target MCU
MCU = atmega16

# Programmer (z.B. avrdude)
PROGRAMMER = avrdude

# Baudrate für serielles Hochladen (falls benötigt)
BAUD = 9600

# Taktfrequenz des Mikrocontrollers
F_CPU = 16000000UL  # 16 MHz, passe an deine Hardware an

# Name der Haupt-C-Datei (ohne .c)
TARGET = main

# AVR-GCC und Tools
CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

# CFLAGS: Kompilierungsflags
CFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -std=gnu99 -Wall -Wextra

# LDFLAGS: Linker-Flags
LDFLAGS = -mmcu=$(MCU)

# Targets
all: $(TARGET).hex

# Übersetzen und Verlinken
$(TARGET).elf: $(TARGET).c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

# Erzeuge Hex-Datei aus ELF-Datei
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# Hochladen des Programms mit avrdude
upload: $(TARGET).hex
	$(AVRDUDE) -p $(MCU) -c $(PROGRAMMER) -U flash:w:$(TARGET).hex:i

# Aufräumen
clean:
	rm -f $(TARGET).elf $(TARGET).hex

