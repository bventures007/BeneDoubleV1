/*
 * Copyright (c) 2018, Microchip.
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
import SAMBA.Device.SAM9X60 3.8

/*!
	\qmltype SAM9X60
	\inqmlmodule SAMBA.Device.SAM9X60
	\brief Contains chip-specific information about SAM9X60 device.

	This QML type contains configuration, applets and tools for supporting
	the SAM9X60 device.

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
	family: "sam9x60"

	name: "sam9x60"

	aliases: [ "sam9x60d5m", "sam9x60d1g", "sam9x60d6k"]

	description: "SAM9X60 series"

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAM9X60Config
	*/
	property alias config: config

	applets: [
		SAM9X60BootConfigApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-bootconfig_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		LowlevelPresetApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevel_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		ExtRamApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-extram_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		SDMMCApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		SerialFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		QSPIFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-qspiflash_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		NANDFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
			nandHeaderHelp: "For information on the NAND header values, please refer to Boot Strategies chapter from SAM9X60 datasheet."
		},
		ResetApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-reset_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		ReadUniqueIDApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-readuniqueid_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		SAM9X60PairingModeApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-pairingmode_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
			connectionType: connectionTypeSecureOnly
        },
        SetGPIOApplet {
            codeUrl: Qt.resolvedUrl("applets/applet-setgpio_sam9x60-generic_sram.bin")
            codeAddr: 0x300000
            mailboxAddr: 0x300004
            entryAddr: 0x300000
        }

	]

	/*!
		\brief Initialize the SAM9X60 device using the current connection.
	*/
	function initialize() {
/*	   var dbgu_cidr = connection.readu32(0xfffff240)
	   var dbgu_extid = connection.readu32(0xfffff244)
	   
	   if (dbgu_cidr === 0x819B35A1 || dbgu_cidr === 0x819B35A2) {
	       if (dbgu_cidr === 0x1) {
                // device is Sam9x60d5m
               if (this.config.extram.preset !== 16) {
                   print("Warning: Invalid Extram config : " +
                     Utils.hex(this.config.extram.preset) + " (expected 16). Check if correct device/board !")
               }
           }
           else if (dbgu_cidr === 0x10) {
                // device is Sam9x60d1g
               if (this.config.extram.preset !== 8) {
                   print("Warning: Invalid Extram config : " +
                     Utils.hex(this.config.extram.preset) + " (expected 8). Check if correct device/board !")
               }
           }
           else if (dbgu_cidr === 0x11) {
                // device is Sam9x60d6k
               if (this.config.extram.preset !== 99) {
                   print("Warning: Invalid Extram config : " +
                     Utils.hex(this.config.extram.preset) + " (expected 99). Check if correct device/board !")
               }
           }
	   }
*/
	}

    /*!
        \brief Initialize the configuration to apply to the device.
    */
    function configDevice(device_name) {
        if (device_name === "sam9x60d5m") {
            /* Windbond W975116KG2-5I*/
            config.extram.preset = 16 /* W9751G6KB */
        }
        else if (device_name === "sam9x60d1g") {
            /* Windbond W971G16SG2-5I*/
            config.extram.preset = 8 /* W971GG6SB */
        }
        else if (device_name === "sam9x60d6k") {
            /* Windbond W986416KG-5I*/
            config.extram.preset = 99 /* to define (W9864G6KH) !!!!*/
        }
        else {
            // do nothing:
            // use the default config defined in that file.
        }
    }

	/*!
		\brief List SAM9X60 specific commands for its secure SAM-BA monitor
	*/
	function commandLineSecureCommands() {
		return ["write_rsa_hash", "enable_pairing"]
	}

	/*!
		\brief Show help for monitor commands supported by a SecureConnection
	*/
	function commandLineSecureCommandHelp(command) {
		if (command === "write_rsa_hash") {
			return ["* write_rsa_hash - write the RSA hash into the device",
			        "Syntax:",
			        "    write_rsa_hash:<file>"]
		}
		if (command === "enable_pairing") {
			return ["* enable_pairing - enable pairing mode",
				"Syntax:",
				"    enable_pairing"]
		}
	}

	/*!
		\brief Handle monitor commands through a SecureConnection

		Handle secure commands specific to the secure SAM-BA monitor
		of SAM9X60 devices.
	*/
	function commandLineSecureCommand(command, args) {
		if (command === "write_rsa_hash")
			return connection.commandLineCommandWriteRSAHash(args)
		if (command === "enable_pairing")
			return connection.commandLineCommandSetPairingMode(args)
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

	SAM9X60Config {
		id: config
	}
}
