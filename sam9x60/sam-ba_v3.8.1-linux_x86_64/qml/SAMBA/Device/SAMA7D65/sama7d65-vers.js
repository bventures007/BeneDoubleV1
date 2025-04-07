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

.pragma library
var TAG             = 0
var NVM_INFO	    = 1
var VERSION		    = 2

var VERSION_PKT_SIZE   = 3


var IOSET_OFF       = 0
var IOSET_MASK      = 0xf << IOSET_OFF

var INST_ID_OFF     = 4
var INST_ID_MASK    = 0xf << INST_ID_OFF


var TYPE_OFF        = 8
var TYPE_MASK       = 0xf << TYPE_OFF
var TYPE_DISABLED   = 0x0 << TYPE_OFF
var TYPE_QSPI       = 0x1 << TYPE_OFF
var TYPE_SPI        = 0x2 << TYPE_OFF
var TYPE_SDMMC      = 0x3 << TYPE_OFF
var TYPE_NFC        = 0x4 << TYPE_OFF
var TYPE_SPIHTOL    = 0x5 << TYPE_OFF


var MIN_VERS_OFF    = 0
var MIN_VERS_MASK   = 0xFFFF << MIN_VERS_OFF

var MAJ_VERS_OFF    = 16
var MAJ_VERS_MASK   = 0xFFFF << MAJ_VERS_OFF


var TAG_BSVP        = 0x50565342



/*!
	\qmlmethod string BCP::toText(Uint32Array value)
	Converts a boot config packet \a value to text for user display.
*/
function toText(value) {
	if (value.length !== VERSION_PKT_SIZE)
		throw new Error("Invalid Boot Version Packet")

	var text = []
    var boot_entry

    var nvm_info = value[NVM_INFO]
    var ioset = ((nvm_info & IOSET_MASK) >> IOSET_OFF) + 1
    var inst_id = (nvm_info & INST_ID_MASK) >> INST_ID_OFF
    
    var version = value[VERSION]
    var min_vers = (version & MIN_VERS_MASK) >> MIN_VERS_OFF
    var maj_vers = (version & MAJ_VERS_MASK) >> MAJ_VERS_OFF

    switch (nvm_info & TYPE_MASK) {
    case TYPE_QSPI:
        boot_entry = "QSPI" + inst_id + "_IOSET" + ioset
        break
    case TYPE_SPI:
        boot_entry = "FLEXCOM" + inst_id + "_SPI_IOSET" + ioset
        break
    case TYPE_SDMMC:
        boot_entry = "SDMMC" + inst_id + "_IOSET" + ioset
        break
    case TYPE_NFC:
        boot_entry = "NFC_IOSET" + ioset
        break
    case TYPE_SPIHTOL:
        boot_entry = "FLEXCOM" + inst_id + "_SPIHTOL_IOSET" + ioset
        break
    default:
    case TYPE_DISABLED:
        boot_entry = ""
        break
    }

    text.push(boot_entry)
    text.push("" + maj_vers)
    text.push("" + min_vers)

	return text.join(",")
}

/*!
	\qmlmethod Uint32Array BCP::fromText(string text)
	Converts a string to a boot config packet \a value.
*/
function fromText(text) {
	var entries = text.split(',')
	var qspi_regexp = /^QSPI(\d)_IOSET(\d)$/i
	var spi_regexp = /^FLEXCOM(\d{1,2})_SPI_IOSET(\d)$/i
	var sdmmc_regexp = /^SDMMC(\d)_IOSET(\d)$/i
	var nfc_regexp = /^NFC_IOSET(\d)$/i
	var spihtol_regexp = /^FLEXCOM(\d{1,2})_SPIHTOL_IOSET(\d)$/i

	var inst_id = 0
	var ioset = 0
    var found = 0
    var nvm_info = 0
	var maj_vers = 0
	var min_vers = 0

	var vers_pckt = new Uint32Array(VERSION_PKT_SIZE)
	if (entries.length >= 1) {
        if ((found = entries[0].match(qspi_regexp)) !== null) {
            inst_id = parseInt(found[1], 10)
            ioset = parseInt(found[2], 10) - 1
            nvm_info = TYPE_QSPI |
                    ((ioset << IOSET_OFF) & IOSET_MASK) |
                    ((inst_id << INST_ID_OFF) & INST_ID_MASK)
        } else if ((found = entries[0].match(spi_regexp)) !== null) {
            inst_id = parseInt(found[1], 10)
            ioset = parseInt(found[2], 10) - 1
            nvm_info = TYPE_SPI |
                    ((ioset << IOSET_OFF) & IOSET_MASK) |
                    ((inst_id << INST_ID_OFF) & INST_ID_MASK)
        } else if ((found = entries[0].match(sdmmc_regexp)) !== null) {
            inst_id = parseInt(found[1], 10)
            ioset = parseInt(found[2], 10) - 1
            nvm_info = TYPE_SDMMC |
                    ((ioset << IOSET_OFF) & IOSET_MASK) |
                    ((inst_id << INST_ID_OFF) & INST_ID_MASK)
        } else if ((found = entries[0].match(nfc_regexp)) !== null) {
            ioset = parseInt(found[1], 10) - 1
            nvm_info = TYPE_NFC |
                    ((ioset << IOSET_OFF) & IOSET_MASK)
        } else if ((found = entries[0].match(spihtol_regexp)) !== null) {
            inst_id = parseInt(found[1], 10)
            ioset = parseInt(found[2], 10) - 1
            nvm_info = TYPE_SPIHTOL |
                    ((ioset << IOSET_OFF) & IOSET_MASK) |
                    ((inst_id << INST_ID_OFF) & INST_ID_MASK)
        }
    }
    
    if (entries.length >= 2) {
        maj_vers = parseInt(entries[1], 10)
    }

    if (entries.length >= 3) {
        min_vers = parseInt(entries[2], 10)
    }


    vers_pckt[TAG] = TAG_BSVP
    vers_pckt[NVM_INFO] = nvm_info
    vers_pckt[VERSION] = ((maj_vers << MAJ_VERS_OFF) & MAJ_VERS_MASK) |
                         ((min_vers << MIN_VERS_OFF) & MIN_VERS_MASK)

	return vers_pckt
}
