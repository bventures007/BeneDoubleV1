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

var DISABLE_MONITOR	    = 0
var CHECK_IMAGE		    = 1
var CONSOLE_IOSET	    = 2
var DISABLE_OTP_PMNGT   = 3

var MAX_BOOTABLE_INTERF	= 4
var SIZE_BOOTABLE_INTERF = 4
var BOOT_CFG_PKT_SIZE	= 20

var OTP_PMNGT_DISABLED_VAL = 0x4D504F44

var IOSET_OFF		= 0
var IOSET_MASK		= 0xf << IOSET_OFF

var INST_ID_OFF		= 4
var INST_ID_MASK	= 0xf << INST_ID_OFF

var DUALBOOT_ENABLE_OFF = 0
var DUALBOOT_ENABLE_MASK = 0xFFFF << DUALBOOT_ENABLE_OFF
var DUALBOOT_ENABLED_VAL = 0x4442 << DUALBOOT_ENABLE_OFF

var ANTIROLLBACK_ENABLE_OFF = 16
var ANTIROLLBACK_ENABLE_MASK = 0xFFFF << ANTIROLLBACK_ENABLE_OFF
var ANTIROLLBACK_ENABLED_VAL = 0x4152 << ANTIROLLBACK_ENABLE_OFF


var TYPE_OFF		= 8
var TYPE_MASK		= 0xf << TYPE_OFF
var TYPE_DISABLED	= 0x0 << TYPE_OFF
var TYPE_QSPI		= 0x1 << TYPE_OFF
var TYPE_SPI		= 0x2 << TYPE_OFF
var TYPE_SDMMC		= 0x3 << TYPE_OFF
var TYPE_NFC		= 0x4 << TYPE_OFF
var TYPE_SPIHTOL	= 0x5 << TYPE_OFF

var CD_ENABLED		= 1 << 7

var CD_MAGIC_OFF	= 8
var CD_MAGIC_MASK	= 0xff << CD_MAGIC_OFF
var CD_MAGIC_PASSWORD	= 0x96 << CD_MAGIC_OFF


var NANDHEADER_USEPMECC_OFF  = 0
var NANDHEADER_USEPMECC_MASK = 0x1 << NANDHEADER_USEPMECC_OFF
var NANDHEADER_USEPMECC_ENALBLED = NANDHEADER_USEPMECC_MASK

var NANDHEADER_NBSECTPERPAGE_OFF  = 1
var NANDHEADER_NBSECTPERPAGE_MASK = 0x7 << NANDHEADER_NBSECTPERPAGE_OFF
var NANDHEADER_NBSECTPERPAGE_1  = 0x0 << NANDHEADER_NBSECTPERPAGE_OFF
var NANDHEADER_NBSECTPERPAGE_2  = 0x1 << NANDHEADER_NBSECTPERPAGE_OFF
var NANDHEADER_NBSECTPERPAGE_4  = 0x2 << NANDHEADER_NBSECTPERPAGE_OFF
var NANDHEADER_NBSECTPERPAGE_8  = 0x3 << NANDHEADER_NBSECTPERPAGE_OFF
var NANDHEADER_NBSECTPERPAGE_16 = 0x4 << NANDHEADER_NBSECTPERPAGE_OFF

var NANDHEADER_SPARESIZE_OFF  = 4
var NANDHEADER_SPARESIZE_MASK = 0x1FF << NANDHEADER_SPARESIZE_OFF

var NANDHEADER_ECCBITREQ_OFF  = 13
var NANDHEADER_ECCBITREQ_MASK = 0x7 << NANDHEADER_ECCBITREQ_OFF
var NANDHEADER_ECCBITREQ_2  = 0x0 << NANDHEADER_ECCBITREQ_OFF
var NANDHEADER_ECCBITREQ_4  = 0x1 << NANDHEADER_ECCBITREQ_OFF
var NANDHEADER_ECCBITREQ_8  = 0x2 << NANDHEADER_ECCBITREQ_OFF
var NANDHEADER_ECCBITREQ_12  = 0x3 << NANDHEADER_ECCBITREQ_OFF
var NANDHEADER_ECCBITREQ_24 = 0x4 << NANDHEADER_ECCBITREQ_OFF

var NANDHEADER_SECTORSIZE_OFF  = 16
var NANDHEADER_SECTORSIZE_MASK = 0x3 << NANDHEADER_SECTORSIZE_OFF
var NANDHEADER_SECTORSIZE_512  = 0x0 << NANDHEADER_SECTORSIZE_OFF
var NANDHEADER_SECTORSIZE_1024  = 0x1 << NANDHEADER_SECTORSIZE_OFF

var NANDHEADER_ECCOFFSET_OFF  = 18
var NANDHEADER_ECCOFFSET_MASK = 0x1FF << NANDHEADER_ECCOFFSET_OFF

var NANDHEADER_KEY_OFF  = 28
var NANDHEADER_KEY_MASK = 0xF << NANDHEADER_KEY_OFF
var NANDHEADER_KEY_VALUE = 0xC << NANDHEADER_KEY_OFF


var romcodeConsoles     = [
	[ 0, 1], [ 0, 2],
	[ 1, 1], [ 1, 2], [ 1, 3],
	[ 2, 1], [ 2, 2], [ 2, 3], [ 2, 4],
	[ 3, 1], [ 3, 2], [ 3, 3], [ 3, 4],
	[ 4, 1],
	[ 5, 1], [ 5, 2],
	[ 6, 1], [ 6, 2], [ 6, 3], [ 6, 4],
	[ 7, 1], [ 7, 2], [ 7, 3],
	[ 8, 1], [ 8, 2], [ 8, 3],
	[ 9, 1], [ 9, 2],
	[10, 1], [10, 2],
]

/*!
	\qmlmethod string BCP::toText(Uint32Array value)
	Converts a boot config packet \a value to text for user display.
*/
function toText(value) {
	if (value.length !== BOOT_CFG_PKT_SIZE)
		throw new Error("Invalid Boot Config Packet")

	var text = []

	if (value[DISABLE_MONITOR] !== 0)
		text.push("MONITOR_DISABLED")

/* NOT USED FOR SAMA7D65
	if (value[CHECK_IMAGE] !== 0)
		text.push("CHECK_IMAGE")
*/

	if (value[CONSOLE_IOSET] < romcodeConsoles.length) {
		var entry = romcodeConsoles[value[CONSOLE_IOSET]]
		var inst_id = entry[0]
		var ioset = entry[1]
		text.push("FLEXCOM" + inst_id + "_USART_IOSET" + ioset)
	} else {
		text.push("CONSOLE_DISABLED")
	}

    if (value[DISABLE_OTP_PMNGT] === OTP_PMNGT_DISABLED_VAL)
        text.push("OTP_PMNGT_DISABLED")

	for (var i = 0; i < MAX_BOOTABLE_INTERF; i++) {
		var details = value[SIZE_BOOTABLE_INTERF * i + 4]
        var mem_cfg = value[SIZE_BOOTABLE_INTERF * i + 5]
        var boot_opt = value[SIZE_BOOTABLE_INTERF * i + 6]
        var dualboot_cfg = value[SIZE_BOOTABLE_INTERF * i + 7]
		var ioset = ((details & IOSET_MASK) >> IOSET_OFF) + 1
		var inst_id = (details & INST_ID_MASK) >> INST_ID_OFF
		var boot_entry

		switch (details & TYPE_MASK) {
		default:
		case TYPE_DISABLED:
			continue
		case TYPE_QSPI:
			boot_entry = "QSPI" + inst_id + "_IOSET" + ioset
			break
		case TYPE_SPI:
			boot_entry = "FLEXCOM" + inst_id + "_SPI_IOSET" + ioset
			break
		case TYPE_SDMMC:
			var cfg_mask = CD_MAGIC_MASK | CD_ENABLED
			var cfg_value = CD_MAGIC_PASSWORD | CD_ENABLED
			boot_entry = "SDMMC" + inst_id + "_IOSET" + ioset
			if ((mem_cfg & cfg_mask) !== cfg_value)
				boot_entry += "_NO_CARD_DETECT"
			break
		case TYPE_NFC:
			boot_entry = "NFC_IOSET" + ioset
			if ((mem_cfg & NANDHEADER_KEY_MASK) === NANDHEADER_KEY_VALUE) {
                boot_entry += "_PMECC0x" + mem_cfg.toString(16).toUpperCase()
            }
			break
		case TYPE_SPIHTOL:
			boot_entry = "FLEXCOM" + inst_id + "_SPIHTOL_IOSET" + ioset
			break
		}

        if ( (boot_opt & ANTIROLLBACK_ENABLE_MASK) === ANTIROLLBACK_ENABLED_VAL) {
            boot_entry += "_AR"
        }
        
        if ( (boot_opt & DUALBOOT_ENABLE_MASK) === DUALBOOT_ENABLED_VAL) {
            boot_entry += "_DB"
            
            if ((details & TYPE_MASK) === TYPE_SDMMC) {
                var WW = (dualboot_cfg>>24)&0xFF
                var XX = (dualboot_cfg>>16)&0xFF
                var YY = (dualboot_cfg>>8)&0xFF
                var ZZ = dualboot_cfg&0xFF
                boot_entry += "@" + String.fromCharCode(WW, XX, YY, ZZ)
            }
            else {
                boot_entry += "@0x" + dualboot_cfg.toString(16).toUpperCase()
            }
        }
        
        

		text.push(boot_entry)
	}

	return text.join(",")
}

/*!
	\qmlmethod Uint32Array BCP::fromText(string text)
	Converts a string to a boot config packet \a value.
*/
function fromText(text) {
	var entries = text.split(',')
	var console_regexp = /^FLEXCOM(\d{1,2})_USART_IOSET(\d)$/i
	var qspi_regexp = /^QSPI(\d)_IOSET(\d)(.*)$/i
	var spi_regexp = /^FLEXCOM(\d{1,2})_SPI_IOSET(\d)(.*)$/i
	var sdmmc_regexp = /^SDMMC(\d)_IOSET(\d)(.*)$/i
	var nfc_regexp = /^NFC_IOSET(\d)_PMECC0x(.*)$/i
	var spihtol_regexp = /^FLEXCOM(\d{1,2})_SPIHTOL_IOSET(\d)(.*)$/i

	var inst_id
	var ioset
	var found
	var header
	var boot_entry = 0
	var bcp = new Uint32Array(BOOT_CFG_PKT_SIZE)
	for (var i = 0; i < entries.length; i++) {
		if (entries[i].toUpperCase() === "MONITOR_DISABLED") {
			bcp[DISABLE_MONITOR] = 1
		} else if (entries[i].toUpperCase() === "CHECK_IMAGE") {
			bcp[CHECK_IMAGE] = 1
        } else if (entries[i].toUpperCase() === "CONSOLE_DISABLED") {
            bcp[CONSOLE_IOSET] = -1
        } else if (entries[i].toUpperCase() === "OTP_PMNGT_DISABLED") {
            bcp[DISABLE_OTP_PMNGT] = OTP_PMNGT_DISABLED_VAL
		} else if ((found = entries[i].match(console_regexp)) !== null) {
			inst_id = 0
			for (var j = 0; j < romcodeConsoles.length; j++) {
				if (romcodeConsoles[j][0] == found[1] &&
				    romcodeConsoles[j][1] == found[2]) {
					inst_id = j
					break
				}
			}
			bcp[CONSOLE_IOSET] = inst_id
		} else if ((found = entries[i].match(qspi_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
			var index_AR = found[3].indexOf("_AR")
			var index_DB = found[3].indexOf("_DB@0x")
			bcp[SIZE_BOOTABLE_INTERF * boot_entry + 4] = TYPE_QSPI |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
			if ((index_AR !== -1) && (index_DB !== -1)){
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL | DUALBOOT_ENABLED_VAL
            }
            else if (index_AR !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL
            }
            else if (index_DB !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = DUALBOOT_ENABLED_VAL
            }
            
            if (index_DB !== -1) {
                var db_info_str = found[3].substring(index_DB+6)
                var db_info_int = parseInt(db_info_str, 16)
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 7] = db_info_int
            }
			boot_entry++
		} else if ((found = entries[i].match(spi_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
            var index_AR = found[3].indexOf("_AR")
            var index_DB = found[3].indexOf("_DB@0x")
			bcp[SIZE_BOOTABLE_INTERF * boot_entry + 4] = TYPE_SPI |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
            if ((index_AR !== -1) && (index_DB !== -1)){
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL | DUALBOOT_ENABLED_VAL
            }
            else if (index_AR !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL
            }
            else if (index_DB !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = DUALBOOT_ENABLED_VAL
            }
            
            if (index_DB !== -1) {
                var db_info_str = found[3].substring(index_DB+6)
                var db_info_int = parseInt(db_info_str, 16)
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 7] = db_info_int
            }
			boot_entry++
		} else if ((found = entries[i].match(sdmmc_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
			bcp[SIZE_BOOTABLE_INTERF * boot_entry + 4] = TYPE_SDMMC |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
			var rest_entry = found[3].toUpperCase()
			if (found[3].toUpperCase().substring(0,15) !== "_NO_CARD_DETECT") {
				bcp[SIZE_BOOTABLE_INTERF * boot_entry + 5] = CD_MAGIC_PASSWORD | CD_ENABLED
				rest_entry=rest_entry.substring(15)
			}
			var index_AR = rest_entry.indexOf("_AR")
            var index_DB = rest_entry.indexOf("_DB@")
            if ((index_AR !== -1) && (index_DB !== -1)){
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL | DUALBOOT_ENABLED_VAL
            }
            else if (index_AR !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL
            }
            else if (index_DB !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = DUALBOOT_ENABLED_VAL
            }
            
            if (index_DB !== -1) {
                var db_info_str = rest_entry.substring(index_DB+4)
                var WW=db_info_str.charCodeAt(0)
                var XX=db_info_str.charCodeAt(1)
                var YY=db_info_str.charCodeAt(2)
                var ZZ=db_info_str.charCodeAt(3)
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 7] = (WW<<24) + (XX<<16) + (YY<<8) + ZZ
            }
			boot_entry++
		} else if ((found = entries[i].match(nfc_regexp)) !== null) {
			ioset = parseInt(found[1], 10) - 1
			var index_end_header = 0
			var index_AR = found[2].indexOf("_AR")
			var index_DB = found[2].indexOf("_DB@0x")
            if ((index_AR !== -1) && (index_DB !== -1)){
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL | DUALBOOT_ENABLED_VAL
                index_end_header = Math.min(index_AR, index_DB)
            }
            else if (index_AR !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL
                index_end_header = index_AR
            }
            else if (index_DB !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = DUALBOOT_ENABLED_VAL
                index_end_header = index_DB
            }
            if (index_end_header === 0) {
                header = parseInt(found[2], 16)
            }
            else {
                header = parseInt(found[2].substring(0,index_end_header), 16)
            }
            bcp[SIZE_BOOTABLE_INTERF * boot_entry + 4] = TYPE_NFC | ((ioset << IOSET_OFF) & IOSET_MASK)
            bcp[SIZE_BOOTABLE_INTERF * boot_entry + 5] = header
            
            if (index_DB !== -1) {
                var db_info_str = found[2].substring(index_DB+6)
                var db_info_int = parseInt(db_info_str, 16)
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 7] = db_info_int
            }

			boot_entry++
		} else if ((found = entries[i].match(spihtol_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
            var index_AR = found[3].indexOf("_AR")
            var index_DB = found[3].indexOf("_DB@0x")
			bcp[SIZE_BOOTABLE_INTERF * boot_entry + 4] = TYPE_SPIHTOL |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
            if ((index_AR !== -1) && (index_DB !== -1)){
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL | DUALBOOT_ENABLED_VAL
            }
            else if (index_AR !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = ANTIROLLBACK_ENABLED_VAL
            }
            else if (index_DB !== -1) {
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 6] = DUALBOOT_ENABLED_VAL
            }
            
            if (index_DB !== -1) {
                var db_info_str = found[3].substring(index_DB+6)
                var db_info_int = parseInt(db_info_str, 16)
                bcp[SIZE_BOOTABLE_INTERF * boot_entry + 7] = db_info_int
            }
			boot_entry++
		}
	}
	return bcp
}
