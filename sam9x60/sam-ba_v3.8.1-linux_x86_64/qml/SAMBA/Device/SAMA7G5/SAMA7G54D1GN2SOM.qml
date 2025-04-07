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
    \qmltype SAMA7G54D1GN2SOM
	\inqmlmodule SAMBA.Device.SAMA7G5
    \brief Contains a specialization of the SAMA7G5 QML type for the
           SAMA7G54D1GN2 SOM module.
*/
SAMA7G5 {
    name: "sama7g54d1gn2-som"

	aliases: []

    description: "SAMA7G54 SOM High End Linux 2G"

	config {
		serial {
			instance: 3 /* FLEXCOM3 USART */
			ioset: 5
		}

        /* SMC, I/O Set 21, 8-bit bus width, 2-Gb SLC Nand Flash MT29F2G08ABAGAH4 or MX30LF2G28AD, PC21 to PC24 / PD2 to PD11
        <nbSectorPerPage>  = number of sectors per page       : 2^(3)
        <spareSize>        = size of spare zone in bytes      : 128
        <eccBitReq>        = number of ECC Bits Required      : 2 (8-bit)
        <sectorSize>       = number of bytes per sector       : 512
        <eccOffset>        = ECC byte offset in spare zone    : 4
        <usePmecc>         = PMECC used                       : 1 (true)
        */
        nandflash {
            ioset: 2
            busWidth: 8
            header: 0xc0104807
        }

        // QPSI0, I/O Set 1, 50MHz, 64-Mb QSPI SST26VF064BEUIT
		qspiflash {
            instance: 1
			ioset: 1
			freq: 50
		}
	}
}
