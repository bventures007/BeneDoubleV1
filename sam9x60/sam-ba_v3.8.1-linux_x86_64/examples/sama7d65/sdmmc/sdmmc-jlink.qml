import SAMBA 3.8
import SAMBA.Connection.JLink 3.8
import SAMBA.Device.SAMA7D65 3.8

JLinkConnection {
	device: SAMA7D65CURIOSITY {
	}

	onConnectionOpened: {
		// initialize SDMMC applet
		initializeApplet("sdmmc")

		// write files
		applet.write(0x00000, "sdcard.img")
	}
}
