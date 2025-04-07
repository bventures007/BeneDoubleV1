import SAMBA 3.8
import SAMBA.Connection.Serial 3.8
import SAMBA.Device.SAM9X7 3.8

SerialConnection {
    device: SAM9X75CURIOSITY {
	}

	onConnectionOpened: {
		// initialize SDMMC applet
		initializeApplet("sdmmc")

		// write files
		applet.write(0x00000, "sdcard.img")
	}
}
