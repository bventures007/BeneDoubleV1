/*
 * Copyright (c) 2019, Microchip.
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
import SAMBA.Device.SAMA7D65 3.8

/*!
	\qmltype SAMA7D65
	\inqmlmodule SAMBA.Device.SAMA7D65
	\brief Contains chip-specific information about SAMA7D65 device.

	This QML type contains configuration, applets and tools for supporting
	the SAMA7D65 device.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.

	\section2 External RAM Applet

	This applet is in charge of configuring the external RAM.

	The Low-Level applet must have been initialized first.

	The only supported command is "init".
*/
Device {
	family: "sama7d65"

	name: "sama7d65"

	aliases: [ "sama7d65d1g", "sama7d65d2g"]

	description: "SAMA7D65 series"

    bootstrap_image: true
	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAMA7D65Config
	*/
	property alias config: config

	applets: [
		SAMA7D65BootConfigApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-bootconfig_sama7d65-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},

		NANDFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sama7d65-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
			nandHeaderHelp: "For information on the NAND header values, please refer to Boot Strategies chapter from SAMA7D65 datasheet."
		},

		QSPIFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-qspiflash_sama7d65-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},
		ReadUniqueIDApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-readuniqueid_sama7d65-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},

		SDMMCApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sama7d65-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
		},
		SerialFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sama7d65-generic_sram.bin")
			codeAddr: 0x100000
			mailboxAddr: 0x100004
			entryAddr: 0x100000
        }

	]

    /*! \internal */
    function commandLineCommandWriteCustomerKeyPayload(args) {
        if (args.length !== 1)
            return "Invalid number of arguments (expected 1)."

        connection.probeDeviceVersion()
        var filename = translateInputFileName(args[0])

        return connection.executeCustomCommand("WCKP", "write", filename)
    }

	/*!
		\brief Initialize the SAMA7D65 device using the current connection.

		This method calls checkDeviceID.
	*/
    function initialize() {
        if ((connection.name === "serial") || (connection.name === "secure")){
            var wdg = connection.readu32(0xe001c004)
            if (wdg !== 0x1000 ) {
                connection.writeu32(0xe001c004, 0x1000)
            }
            wdg = connection.readu32(0xe001d004)
            if (wdg !== 0x1000 ) {
                connection.writeu32(0xe001d004, 0x1000)
            }
        }
    }

	/*!
		\brief List SAMA7D65 specific commands for its secure SAM-BA monitor
	*/
	function commandLineSecureCommands() {
		return ["write_customer_key_payload", "write_customer_key"]
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
	}

	/*!
		\brief Handle monitor commands through a SecureConnection

		Handle secure commands specific to the secure SAM-BA monitor
		of SAMA7D65 devices.
	*/
	function commandLineSecureCommand(command, args) {
        if (command === "write_customer_key_payload")
            return commandLineCommandWriteCustomerKeyPayload(args)
        if (command === "write_customer_key")
            return connection.commandLineCommandWriteCustomerKey(args)
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

	SAMA7D65Config {
		id: config
	}
}
