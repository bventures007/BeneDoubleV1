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
import SAMBA.Device.SAM9X7 3.8

/*!
    \qmltype SAM9X75-CURIOSITY
	\inqmlmodule SAMBA.Device.SAM9X7
	\brief Contains a specialization of the SAM9X7 QML type for the
            SAM9X75-CURIOSITY board.
*/
SAM9X7 {
    name: "sam9x75-curiosity"

	aliases: []

    description: "SAM9X75 Curiosity Board"

	config {
		serial {
			instance: 0 /* DBGU */
			ioset: 1
		}

		// SDMMC0, I/O Set 1, User Partition, Automatic bus width, 3.3V
		sdmmc {
			instance: 0
			ioset: 1
			partition: 0
			busWidth: 0
			voltages: 4 /* 3.3V */
		}

        // FlexCom->SPI3, I/O Set 1, NPCS1, 50MHz
		serialflash {
            instance:3
			ioset: 1
            chipSelect: 1
			freq: 50
		}

        // SST26VF064B, QPSI0, I/O Set 1, 50MHz
		qspiflash {
			instance: 0
			ioset: 1
			freq: 50
		}

        // MX30LF4G28AD, 8-bit ECC, 256-byte spare area, 4K bytes page flash
        nandflash {
			ioset: 1
			busWidth: 8
            header: 0xc2605007
		}
	}
}
