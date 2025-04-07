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

var EMULATION_MODE_OFFSET   = 0x0
var EMULATION_MODE_MASK     = 0xFF << EMULATION_MODE_OFFSET
var EMULATION_MODE_VAL      = 0xE << EMULATION_MODE_OFFSET

var SECURAM_PROTECT_OFFSET   = 0x8
var SECURAM_PROTECT_MASK     = 0xFF << SECURAM_PROTECT_OFFSET
var SECURAM_PROTECT_VAL      = 0x3 << SECURAM_PROTECT_OFFSET

/*!
	\qmlmethod string BSCR::toText(int value)
	Converts a boot sequence config register \a value to text for user display.
*/
function toText(value) {
    var text = []
    if ((value & EMULATION_MODE_MASK) === EMULATION_MODE_VAL)
        text.push("EMULATION_ENABLED")
    else
        text.push("EMULATION_DISABLED")

    if ((value & SECURAM_PROTECT_MASK) === SECURAM_PROTECT_VAL)
        text.push("OTP_PACKETS_COPY_IN_SECURAM_DISABLED")
    else
        text.push("OTP_PACKETS_COPY_IN_SECURAM_ENABLED")

    return text.join(",")

}

/*!
	\qmlmethod int BSCR::fromText(string text)
	Converts a string to a boot sequence config register \a value.
*/
function fromText(text) {
    var entries = text.split(',')
    var bscr = 0
    
    for (var i = 0; i < entries.length; i++) {
        if (entries[i].toUpperCase() === "EMULATION_ENABLED") {
            bscr = bscr | EMULATION_MODE_VAL
        } else if (entries[i].toUpperCase() === "OTP_PACKETS_COPY_IN_SECURAM_DISABLED") {
            bscr = bscr | SECURAM_PROTECT_VAL
        } else if ((entries[i].toUpperCase() === "EMULATION_DISABLED") || 
                  (entries[i].toUpperCase() === "OTP_PACKETS_COPY_IN_SECURAM_ENABLED")) {
                    /*do nothing*/
        } else {
                throw new Error("Invalid BSCR value '" + entries[i].toUpperCase() + "'")
        }
    }

    return bscr

}
