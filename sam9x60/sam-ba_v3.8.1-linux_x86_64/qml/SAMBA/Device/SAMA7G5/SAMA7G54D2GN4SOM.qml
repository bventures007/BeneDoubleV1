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
import SAMBA.Device.SAMA7G5 3.8

/*!
    \qmltype SAMA7G54D2GN4SOM
    \inqmlmodule SAMBA.Device.SAMA7G5
    \brief Contains a specialization of the SAMA7G5 QML type for the
           SAMA7G54D2GN4 SOM module.
*/
SAMA7G5 {
    name: "sama7g54d2gn4-som"

	aliases: []

    description: "SAMA7G54 SOM High End Linux 2G"

	config {
		serial {
			instance: 3 /* FLEXCOM3 USART */
			ioset: 5
		}

        /* SMC, I/O Set 2, 8-bit bus width, 4-Gb SLC Nand Flash MT29F4G08ABAFAH4 or MX30LF4G28AD, PC21 to PC24 / PD2 to PD11
        <nbSectorPerPage>  = number of sectors per page       : 2^(3)
        <spareSize>        = size of spare zone in bytes      : 256
        <eccBitReq>        = number of ECC Bits Required      : 2 (8-bit)
        <sectorSize>       = number of bytes per sector       : 512
        <eccOffset>        = ECC byte offset in spare zone    : 152
        <usePmecc>         = PMECC used                       : 1 (true)
        */
        nandflash {
            ioset: 2
            busWidth: 8
            header: 0xc2605007
        }

        // QPSI0, I/O Set 1, 50MHz, 64-Mb QSPI SST26VF064BEUIT
		qspiflash {
            instance: 1
			ioset: 1
			freq: 50
		}
	}
}
