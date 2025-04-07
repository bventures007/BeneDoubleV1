import SAMBA 3.8
import SAMBA.Connection.Serial 3.8
import SAMBA.Device.SAMA7G5 3.8

SerialConnection {
	device: SAMA7G5-EK {
	}

	onConnectionOpened: {
		// initialize SDMMC applet
		initializeApplet("sdmmc")

		// write files
		applet.write(0x00000, "sdcard.img")
	}
}
