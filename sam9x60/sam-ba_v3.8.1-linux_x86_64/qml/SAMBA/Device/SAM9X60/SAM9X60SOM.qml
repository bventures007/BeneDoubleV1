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

import QtQuick 2.3
import SAMBA.Device.SAM9X60 3.8

/*!
	\qmltype SAM9X60SOM
	\inqmlmodule SAMBA.Device.SAM9X60
	\brief Contains a specialization of the SAM9X60 QML type for the
	       SAM9X60 SOM.
*/
SAM9X60 {
	name: "sam9x60d1g-som"

	aliases: [ ]

	description: "SAM9X60 SOM"

    /*!
        \brief Initialize the configuration to apply to the device.
    */
    function configBoard(board_name) {
    
        var device_name
        
        
        if (board_name === "sam9x60d1g-som" || board_name === "sam9x60d1g-i/lzb") {
            device_name = "sam9x60d1g"
            configDevice(device_name) 
        }
        else {
            // do nothing:
            // use the default config defined in that file.
        }
    }
    
	config {
		// SMC, I/O Set 1, 8-bit bus width, MT29F4G08ABAEAWP or MX30LF4G28AD
		nandflash {
			ioset: 1
			busWidth: 8
            //header: 0xc1e04e07 /* 8 sectors (512 Byte) per page - 8 bits ECC - ECC offset: 120 Byte - spare: 224 Byte  */
            header: 0xc2605007 /* 8 sectors (512 Byte) per page - 8 bits ECC - ECC offset: 152 Byte - spare: 256 Byte  */
		}
	}
}
