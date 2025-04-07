/*
 * Copyright (c) 2021, Microchip.
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

/* Cust Key Applet properties */

/*! \qmlproperty int CustKey::CMAC
	\brief Index for CMAC.
*/
var algoCMAC = 0

/*! \qmlproperty int CustKey::RSA
	\brief Index for RSA.
*/
var algoRSA = 1

/*!
	\qmlmethod string CustKey::toText(int value)
	Converts from authentication algorithm value to text for user display.
*/
function toText(value) {
	var algo

	switch (value) {
		case algoCMAC:
			algo = "CMAC"
			break
		case algoRSA:
			algo = "RSA"
			break
		default:
			algo = ""
			break
	}

	return algo
}

/*!
	\qmlmethod string CustKey::fromText(string text)
	Converts from authentication algorithm text to value.
*/
function fromText(value) {
	var algo

	switch (value) {
		case "CMAC":
			algo = algoCMAC
			break
		case "RSA":
			algo = algoRSA
			break
		default:
			algo = undefined
			break
	}

	return algo
}
