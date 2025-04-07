/*
 * Copyright (c) 2024, Microchip.
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
    \qmltype SAM9X75D2GN4SOM
    \inqmlmodule SAMBA.Device.SAM9X7
    \brief Contains a specialization of the SAM9X75 QML type for the SAM9X75 SOM.
*/
SAM9X7 {
    name: "sam9x75d2gn4-som"

    aliases: [ ]

    description: "SAM9X75 SOM 2G nand 4G"

    config {
        serial {
            instance: 0 /* DBGU */
            ioset: 1
        }

        // QPSI0, I/O Set 1, 50MHz, 64-Mb QSPI SST26VF064BEUIT, PB19 to PB24
        qspiflash {
            instance: 0
            ioset: 1
            freq: 50
        }

        /* SMC, I/O Set 1, 8-bit bus width, 4-Gb SLC Nand Flash MT29F4G08ABAFAH4 or MX30LF4G28AD, PD0 to PD14
        <nbSectorPerPage>  = number of sectors per page       : 2^(3)
        <spareSize>        = size of spare zone in bytes      : 256
        <eccBitReq>        = number of ECC Bits Required      : 2 (8-bit)
        <sectorSize>       = number of bytes per sector       : 512
        <eccOffset>        = ECC byte offset in spare zone    : 152
        <usePmecc>         = PMECC used                       : 1 (true)
        */
        nandflash {
            ioset: 1
            busWidth: 8
            header: 0xc2605007
        }
    }
}
