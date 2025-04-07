/*
 * Copyright (c) 2022, Microchip.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

import QtQuick 2.3
import SAMBA 3.8
import SAMBA.Applet 3.8
import SAMBA.Device.SAM9X7 3.8

/*!
    \qmltype SAM9X7
    \inqmlmodule SAMBA.Device.SAM9X7
	\brief Contains chip-specific information about SAM9X7 device family.

	This QML type contains configuration, applets and tools for supporting
	the SAM9X7 device family.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.
*/
Device {
    family: "sam9x7"

    name: "sam9x7"

    aliases: [ "sam9x70", "sam9x72", "sam9x75", "sam9x75d5m", "sam9x75d1g", "sam9x75d2g" ]

    description: "SAM9X7x Series"

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAM9X7Config
	*/
	property alias config: config

	applets: [
        ResetApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-reset_sam9x70-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
        },
        ReadUniqueIDApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-readuniqueid_sam9x70-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
        },
        SAM9X7BootConfigApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-bootconfig_sam9x70-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
        },
        SDMMCApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sam9x70-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
        },
        QSPIFlashApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-qspiflash_sam9x70-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
        },
        NANDFlashApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sam9x70-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
            nandHeaderHelp: "For information on NAND header values, please refer to SAM9X7x datasheet Boot Strategy chapter\"."
        },
        SerialFlashApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sam9x70-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
        },
        SetGPIOApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-setgpio_sam9x70-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
        }
	]

    /*!
        \brief Initialize the configuration to apply to the device.
    */
    function configDevice(device_name) {
        if (device_name === "sam9x75d5m") {
            /* Windbond W975116KG2-5I*/
           // config.extram.preset = 16 /* W9751G6KB */
        }
        else if (device_name === "sam9x75d1g") {
            /* Windbond W971G16SG2-5I*/
          //  config.extram.preset = 8 /* W971GG6SB */
        }
        else if (device_name === "sam9x75d2g") {
            /* Windbond W986416KG-5I*/
         //   config.extram.preset = 99 /* to define (W9864G6KH) !!!!*/
        }
        else {
            // do nothing:
            // use the default config defined in that file.
        }
    }

    /*! \internal */
    function commandLineCommandWriteCustomerKeyPayload(args) {
        if (args.length !== 1)
            return "Invalid number of arguments (expected 1)."

        connection.probeDeviceVersion()
        var filename = translateInputFileName(args[0])

        return connection.executeCustomCommand("WCKP", "write", filename)
    }

    /*!
        \brief List SAM9X7 specific commands for its secure SAM-BA monitor
    */
    function commandLineSecureCommands() {
        return ["write_customer_key_payload", "write_customer_key", "disable_monitor"]
    }

    /*!
        \brief Show help for monitor commands supported by a SecureConnection
    */
    function commandLineSecureCommandHelp(command) {
        if (command === "write_customer_key_payload") {
            return ["* write_customer_key_payload - write the customer key payload (encrypted with RSA) into the device",
                "Syntax:",
                "    write_customer_key_payload:<file>"]
        }
        if (command === "write_customer_key") {
            return ["* write_customer_key - write the customer key payload (encrypted with AES) into the device",
                "Syntax:",
                "    write_customer_key:<file>"]
        }
        if (command === "disable_monitor") {
            return ["* disable_monitor - disable the secure SAM-BA monitor",
                "Syntax:",
                "    disable_monitor"]
        }
    }


    /*!
        \brief Handle monitor commands through a SecureConnection

        Handle secure commands specific to the secure SAM-BA monitor
        of SAM9X7 devices.
    */
    function commandLineSecureCommand(command, args) {
        if (command === "write_customer_key_payload")
            return commandLineCommandWriteCustomerKeyPayload(args)
        if (command === "write_customer_key")
            return connection.commandLineCommandWriteCustomerKey(args)
        if (command === "disable_monitor")
            return connection.commandLineCommandNoArgs("SMDI", args)
    }

    /*! \internal */
    function strerror(code) {
        switch (code) {
        case 0:
            return "OK"
        case -1:
            return "Command parsing error"
        case -2:
            return "Operation code field size error"
        case -3:
            return "Address field size error"
        case -4:
            return "Invalid command length"
        case -5:
            return "Memory ID field size error"
        case -6:
            return "Read/Write field size error"
        case -7:
            return "Unknown operation code"
        case -8:
            return "Customer Key length error"
        case -9:
            return "Customer Key not written"
        case -10:
            return "Customer Key already written"
        case -11:
            return "CMAC Authentication error"
        case -12:
            return "AES-CBC Decryption error"
        case -13:
            return "Key Derivation error"
        case -14:
            return "Fuse Write Disabled"
        case -15:
            return "Bootstrap File size error"
        case -16:
            return "Fuse Secure Mode error"
        case -17:
            return "RSA Hash not written"
        case -18:
            return "RSA Hash already written"
        case -19:
            return "OTP write error"
        case -20:
            return "Expand Mode already written"
        }
    }

    SAM9X7Config {
        id: config
    }
}
