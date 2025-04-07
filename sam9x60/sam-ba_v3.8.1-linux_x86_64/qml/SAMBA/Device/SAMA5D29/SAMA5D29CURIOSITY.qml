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
import SAMBA 3.8
import SAMBA.Applet 3.8
import SAMBA.Device.SAMA5D2 3.8
import SAMBA.Device.SAMA5D29 3.8

/*!
	\qmltype SAMA5D29
	\inqmlmodule SAMBA.Device.SAMA5D29
	\brief Contains chip-specific information about SAMA5D29 device.

	This QML type contains configuration, applets and tools for supporting
	the SAMA5D29 device.
*/
SAMA5D29 {
	name: "sama5d29-curiosity"

	aliases: [ ]

	description: "SAMA5D29 Curiosity Platform"
	
    config {
        // QPSI1, I/O Set 2, 66MHz
        qspiflash {
            instance: 1
            ioset: 2
            freq: 66
        }

    }
}
