import SAMBA 3.8
import SAMBA.Connection.Serial 3.8
import SAMBA.Device.SAMA5D2 3.8

/*
 * This example demonstrates the declaration of a custom board configuration
 * using an external QML file.
 *
 * The configuration in this example matches the SAMA5D2 Xplained Ultra board.
 */
SerialConnection {
	device: MyCustomBoard {
	}

	onConnectionOpened: {
		// initialize serial flash applet
		initializeApplet("serialflash")

		// (...)
	}
}
