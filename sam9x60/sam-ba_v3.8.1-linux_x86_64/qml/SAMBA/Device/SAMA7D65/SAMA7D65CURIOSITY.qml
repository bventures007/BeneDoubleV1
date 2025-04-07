/*
 * Copyright (c) 2020, Microchip.
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
import SAMBA.Device.SAMA7D65 3.8

/*!
	\qmltype SAMA7D65DD3EB
	\inqmlmodule SAMBA.Device.SAMA7D65
	\brief Contains a specialization of the SAMA7D65 QML type for the
	       SAMA7D65 FPGA plateform.
*/
SAMA7D65 {
	name: "sama7d65-curiosity"

	aliases: []

	description: "SAMA7D65 Curiosity Platform"

	is_fpga: false

	config {
		serial {
			instance: 6 /* FLEXCOM6 USART */
			ioset: 4
		}

		// SDMMC1, I/O Set 0, User Partition, Automatic bus width, 3.3V
		sdmmc {
			instance: 1
			ioset: 1
			partition: 0
			busWidth: 4
			voltages: 4 /* 3.3V */
		}

		// QPSI0, I/O Set 1, 50MHz
		qspiflash {
			instance: 0
			ioset: 1
			freq: 50
		}

        // SMC, I/O Set 1, 8-bit bus width, MX30LF4G28AD-XKI
		nandflash {
			ioset: 1
			busWidth: 8
			header: 0xc2605007 /* 8 sectors (512 Byte) per page - 8 bits ECC - ECC offset: 152 Byte - spare: 256 Byte  */
		}

        // FlexCom->SPI4, I/O Set 1, NPCS0, 40MHz
        serialflash {
            instance:4
            ioset: 1
            chipSelect: 0
            freq: 40
        }

	}
}
