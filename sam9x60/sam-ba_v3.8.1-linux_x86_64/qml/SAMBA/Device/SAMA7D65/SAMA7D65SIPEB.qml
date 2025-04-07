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
	\qmltype SAMA7D65SIPEB
	\inqmlmodule SAMBA.Device.SAMA7D65
	\brief Contains a specialization of the SAMA7D65 QML type for the
	       SAMA7D65 SIP plateform.
*/
SAMA7D65 {
    name: "sama7d65-sip-eb"

    aliases: []

    description: "SAMA7D65-SIP-EB Platform"

	is_fpga: false

	config {
		serial {
			instance: 4 /* FLEXCOM4 USART */
			ioset: 1
		}

		// SDMMC1, I/O Set 0, User Partition, Automatic bus width, 3.3V
		sdmmc {
			instance: 1
			ioset: 1
			partition: 0
			busWidth: 0
			voltages: 4 /* 3.3V */
		}

		// QPSI0, I/O Set 1, 50MHz
		qspiflash {
			instance: 0
			ioset: 1
			freq: 50
		}

		nandflash {
			ioset: 1
			busWidth: 8
			header: 0xC0085007
		}

        // FlexCom->SPI1, I/O Set 2, NPCS0, 40MHz
        serialflash {
            instance:1
            ioset: 2
            chipSelect: 0
            freq: 40
        }

	}
}
