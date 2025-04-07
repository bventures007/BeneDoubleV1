import SAMBA 3.8
import SAMBA.Connection.JLink 3.8
import SAMBA.Device.SAM9X7 3.8

JLinkConnection {
    device: SAM9X75CURIOSITY {
	}

	onConnectionOpened: {
        // initialize NAND flash applet
        initializeApplet("nandflash")

		// erase all memory
		applet.erase(0, applet.memorySize)

        // write files
        applet.write(0x00000, "at91bootstrap.img", true)
        applet.write(0x00040000, "u-boot.bin")
        applet.write(0x00140000, "u-boot-env.bin")
        applet.write(0x00180000, "sam9x75_curiosity.dtb")
        applet.write(0x00800000, "zImage")
	}
}
