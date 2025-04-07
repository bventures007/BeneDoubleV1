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
    \qmltype SAMA7G54D1GN0SOM
	\inqmlmodule SAMBA.Device.SAMA7G5
	\brief Contains a specialization of the SAMA7G5 QML type for the
           SAMA7G54D1GN0 SOM module.
*/
SAMA7G5 {
    name: "sama7g54d1gn0-som"

	aliases: []

    description: "SAMA7G54 SOM High End Linux 2G"

	config {
		serial {
			instance: 3 /* FLEXCOM3 USART */
			ioset: 5
		}

        // QPSI1, I/O Set 1, 50MHz, 64-Mb QSPI SST26VF064BEUIT, PB22 to PB27
		qspiflash {
            instance: 1
			ioset: 1
			freq: 50
		}
	}
}
