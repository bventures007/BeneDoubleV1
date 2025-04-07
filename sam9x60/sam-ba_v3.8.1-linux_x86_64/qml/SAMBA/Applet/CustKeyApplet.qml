/*
 * Copyright (c) 2021, Microchip Technology.
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

/*! \internal */
Applet {
    name: "custkey"
    description: "This applet comes in replacement of the WriteCustKey Secure Monitor command, and is to be used to write a customer key as well as to verify an existing key against a provided custkey.cip file."
	commands: [
		AppletCommand { name:"initialize"; code:0 },
        AppletCommand { name:"verify"; code:0x39 },
        AppletCommand { name:"write"; code:0x40 }
    ]

	/* applet status */
	readonly property int statusSuccess: 0

	/* key status */
	readonly property int keyOK: 0
	readonly property int keyNotOK: 1
	readonly property int keyNotWritten: 2
	readonly property int keyInval: 3
    readonly property int keyWritten: 4

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands() {
        return [ "verify", "write" ]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {

        if (command === "verify") {

            /* prepare help message */
            var helpMsgVerify = ["* verify - compares target written keys with the provided one",
                           "Syntax:"]

            var isRSASupported = device.isAuthMethodSupported(CustKey.toText(CustKey.algoRSA))
            if (isRSASupported)
                helpMsgVerify = helpMsgVerify.concat("    verify:<cmac | rsa>:<key>")
            else
                helpMsgVerify = helpMsgVerify.concat("    verify:<cmac>")

            helpMsgVerify = helpMsgVerify.concat("Examples:",
                           "    verify:cmac:customer_key_cmac.cip")

            if (isRSASupported)
                helpMsgVerify = helpMsgVerify.concat("    verify:rsa:customer_rsa_hash.cip")

            return helpMsgVerify
        }

        else if (command === "write") {

            /* prepare help message */
            var helpMsgWrite = ["* write - writes customer key in fuses",
                           "Syntax: write:cmac:customer_key.cip"]

            return helpMsgWrite
        }
	}

	/*! \internal */
	function commandLineCheckArgs(args) {

		if (args.length !== 2)
			throw new Error("Invalid number of arguments (expected 2)")

		if (args[0].length === 0)
			throw new Error("Invalid <key_type> parameter (empty)")

		var algo = args[0].toUpperCase()

		if (!device.isAuthMethodSupported(algo))
			throw new Error("Invalid <key_type> parameter (not recognized)")

		if (args[1].length === 0)
			throw new Error ("Invalid <key> parameter (empty)")
	}

	/*! \internal */
    function verify(algo, file) {

		var keyFile = File.open(file, false)
		if (!keyFile)
			throw new Error("Could not read from customer key file '" + file + "'")

		/* save real file size (without padding), then add padding to align
		   the file size to the page size */
        var realSize = keyFile.size()
		if ((realSize & (pageSize - 1)) !== 0) {
			var paddingAfter = pageSize - (realSize & (pageSize - 1))
			keyFile.setPaddingAfter(paddingAfter)
        }

		try {

			var numPages = keyFile.size() / pageSize
			if (numPages > bufferPages)
				throw new Error("Key size is too big")

            var cmd = command("verify")
			var applet_args = [algo]

			var data = keyFile.read(keyFile.size())
			if (data === undefined || data.byteLength !== keyFile.size())
				throw new Error("Could not read from file '" + file + "'")

           if (!connection.appletBufferWrite(data))
               throw new Error("Could not write applet buffer")

			var status = connection.appletExecute(cmd, applet_args)

			if (status === statusSuccess)
				return connection.appletMailboxRead(0)

			return undefined
		}

		finally {
			keyFile.close()
		}
	}

	/*! \internal */
    function commandLineVerify(args) {

		commandLineCheckArgs(args)

        var status = verify(CustKey.fromText(args[0].toUpperCase()), args[1])

		if (status === undefined)
				throw new Error("Failed to run applet")

		if (status === keyOK)
			print("Key OK!")

		if (status === keyNotOK)
			print("Key written differs from the provided one!")

		if (status === keyNotWritten)
			print("Key not written!")

		if (status === keyInval)
            print("Key provided is invalid!")

    }


    /*! \internal */
    function write(algo, file) {

        var keyFile = File.open(file, false)
        if (!keyFile)
            throw new Error("Could not read from customer key file '" + file + "'")

        /* save real file size (without padding), then add padding to align
           the file size to the page size */
        var realSize = keyFile.size()
        if ((realSize & (pageSize - 1)) !== 0) {
            var paddingAfter = pageSize - (realSize & (pageSize - 1))
            keyFile.setPaddingAfter(paddingAfter)
        }

        try {

            var numPages = keyFile.size() / pageSize
            if (numPages > bufferPages)
                throw new Error("Key size is too big")

            var cmd = command("write")
            var applet_args = [algo]

            var data = keyFile.read(keyFile.size())
            if (data === undefined || data.byteLength !== keyFile.size())
                throw new Error("Could not read from file '" + file + "'")

            if (!connection.appletBufferWrite(data))
                throw new Error("Could not write applet buffer")

            var status = connection.appletExecute(cmd, applet_args)

            if (status === statusSuccess)
                return connection.appletMailboxRead(0)

            return undefined
        }

        finally {
            keyFile.close()
        }
    }

    /*! \internal */
    function commandLineWrite(args) {

        commandLineCheckArgs(args)

        var status = write(CustKey.fromText(args[0].toUpperCase()), args[1])

        if (status === undefined)
                throw new Error("Failed to run applet")

        if (status === keyOK)
            print("Customer key written")

        if (status === keyNotOK)
            print("Customer key not written")

        if (status === keyInval)
            print("Key provided is invalid!")

        if (status === keyWritten)
            print("Key already written")
    }

	/*! \internal */
	function commandLineCommand(command, args) {
        if (command === "verify")
            return commandLineVerify(args)
        else if (command === "write")
            return commandLineWrite(args)
		else
			return "Unknown command."
	}
}
