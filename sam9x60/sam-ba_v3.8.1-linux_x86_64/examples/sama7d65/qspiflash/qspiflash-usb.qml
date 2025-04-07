import SAMBA 3.8
import SAMBA.Connection.Serial 3.8
import SAMBA.Device.SAMA7D65 3.8

SerialConnection {
	device: SAMA7D65CURIOSITY {
	}

	onConnectionOpened: {
		// initialize QSPI flash applet
		initializeApplet("qspiflash")

		// erase all memory
		applet.erase(0, applet.memorySize)

		// write files
		applet.write(0x00000, "at91bootstrap.img")
		applet.write(0x40000, "u-boot.bin")
        applet.write(0x240000, "u-boot-env.bin")
		applet.write(0x280000, "sama7d65_curiosity.dtb")
		applet.write(0x28c000, "zImage")
	}
}
