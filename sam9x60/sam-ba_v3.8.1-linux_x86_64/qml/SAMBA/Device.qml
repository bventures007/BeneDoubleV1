/*
 * Copyright (c) 2015-2016, Atmel Corporation.
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

/*!
	\qmltype Device
	\inqmlmodule SAMBA
	\brief Defines all required data for a given Device
*/
Item {
	/*!
		\qmlproperty Connection Device::connection
		\brief The parent connection object
	*/
	property var connection

	/*!
		\qmlproperty string Device::family
		\brief The device family
	*/
	property var family

	/*!
		\qmlproperty string Device::name
		\brief The device name
	*/
	property var name

	/*!
		\qmlproperty string Device::description
		\brief The device description
	*/
	property var description

	/*!
		\qmlproperty list<string> Device::aliases
		\brief The connection aliases (alternate names that can be used
		on the command-line)
	*/
	property var aliases

	/*!
		\qmlproperty bool Device::usb_zlp_quirk
		\brief Work-around for devices that don't sent zero-length
		packets
	*/
	property bool usb_zlp_quirk: false

    /*!
        \qmlproperty bool Device::is_fpga
        \brief If true, the target is a FPGA platform
    */
    property bool is_fpga: false

    /*!
        \qmlproperty bool Device::bootstrap_image
        \brief If true, the target boots on bootstrap image
    */
    property bool bootstrap_image: false

	/*!
		\qmlproperty string Device::applets
		\brief A list of all supported applets for the device
	*/
	property list<Applet> applets

	/*!
		\qmlproperty bool Device::hasMultipleROMVersions
		\brief If true, read the ROM code version to select the relevant
		files before executing secure applets or any of the WSMD, WCKY,
		WRHA or WFCK secure monitor commands
	*/
	property bool hasMultipleROMVersions: false

	/*! \internal */
	property int activeROMVersion: -1

    /*!
        \qmlproperty string Device::bootstrapImageFormat
        \brief Version of the bootstrap image format
    */
    property var bootstrapImageFormat: 0x31

    /*!
        \qmlproperty string Device::bootstrapHeaderMagic
        \brief Magic value for the type of bootstrap image
    */
    property var bootstrapHeaderMagic: 0x00505342    + (bootstrapImageFormat<<24)

    /*!
        \qmlproperty string Device::bootstrapImageHeaderSize
        \brief Size in bytes of the bootstrap image format header
    */
    property var bootstrapImageHeaderSize: 48


	/*! \internal */
	function setActiveROMVersion(version) {
		activeROMVersion = 0
	}

	/*! \internal */
	function translateSecureAppletUrl(codeUrl) {
		return codeUrl
	}

	/*! \internal */
	function translateInputFileName(filename) {
		return filename
	}

	/*!
		\qmlmethod list<string> Device::appletNames()
		Returns a list of the names of all the applets.
	*/
	function appletNames() {
		var names = []
		for (var i = 0; i < applets.length; i++)
			names.push(applets[i].name)
		return names
	}

	/*!
		\qmlmethod list<string> Device::securedAppletNames()
		Return a list of the names of all the secured applets.
	*/
	function securedAppletNames() {
		var names = []
		for (var i = 0; i < applets.length; i++)
			if (applets[i].connectionType === applets[i].connectionTypeAll ||
			    applets[i].connectionType === applets[i].connectionTypeSecureOnly)
				names.push(applets[i].name)
		return names
	}

	/*!
		\qmlmethod list<string> Device::nonSecuredAppletNames()
		Return a list of the names of all the non-secured applets.
	*/
	function nonSecuredAppletNames() {
		var names = []
		for (var i = 0; i < applets.length; i++)
			if (applets[i].connectionType === applets[i].connectionTypeAll ||
			    applets[i].connectionType === applets[i].connectionTypeNonSecureOnly)
				names.push(applets[i].name)
		return names
	}

	/*!
		\qmlmethod Applet Device::applet(string name)
		Returns the applet with name \a name or \a undefined if not found.
	*/
	function applet(name) {
		for (var i = 0; i < applets.length; i++)
			if (applets[i].name === name &&
			    ((applets[i].connectionType === applets[i].connectionTypeAll) ||
			     (applets[i].connectionType === applets[i].connectionTypeNonSecureOnly && !connection.toSecureMonitor()) ||
			     (applets[i].connectionType === applets[i].connectionTypeSecureOnly && connection.toSecureMonitor())))
				return applets[i]
		return
	}

	/*!
		\qmlmethod void Device::initialize()
		Initialize the device using configured connection.
	*/
	function initialize() {
		// do nothing
	}


    /*!
        \qmlmethod void Device::configBoard()
        Initialize the configuration to apply to a board once created.
    */
    function configBoard(board_name) {
        // do nothing
    }


    /*!
        \qmlmethod void Device::configDevice()
        Initialize the configuration to apply to a device once created.
    */
    function configDevice(device_name) {
        // do nothing
    }


    /*!
        \qmlmethod void Device::generateBootstrapImage(string fileName, string out_fileName, string maj_version, string min_version)
        \brief Generate a bootable booststrap image from binary application.
    */
    function generateBootstrapImage(fileName, out_fileName, maj_version, min_version)
    {
        var total_size
        var paddingAfter = 0
        var version
        
        var file = File.open(fileName, false)
        if (!file)
            throw new Error("Could not read from file '" + fileName + "'")

        var outFile = File.open(out_fileName, true)
        if (!outFile)
            throw new Error("Could not write to file '" + out_fileName + "'")

        version = Utils.parseInteger(maj_version)<<16
        version |= Utils.parseInteger(min_version)

        total_size = file.size()
        // add padding after data if required
        var bootstrap_block_size_bytes = 16
        if ((total_size & (bootstrap_block_size_bytes - 1)) !== 0) {
            paddingAfter = bootstrap_block_size_bytes - (total_size & (bootstrap_block_size_bytes - 1))

            print("Appending " + paddingAfter + " bytes of padding to fill the last written page")

            total_size += paddingAfter
        }

        var header = createBootstrapHeader(total_size, version)

        /* Write header (data + hash) */
        outFile.write(header[0])
        outFile.write(header[1])

        /* Calculate image Hash */
        Hash.reset()
        /* Now copy bootstrap */
        var current = 0
        while (current < file.size())
        {
            var buffer_size = 2048
            var nb_Data_read = Math.min(file.size()-current, buffer_size)

            file.seek(current)
            var read_data = file.read(nb_Data_read)
            outFile.write(read_data)
            Hash.addData(read_data) // bootstrap data used to calculate hash
            current += nb_Data_read
        }
        /* Add padding (random) if needeed */
        if (paddingAfter) {
            var randomArray = new ArrayBuffer(paddingAfter)
            var randomView = new DataView(randomArray)

            var idx
            for (idx=0; idx<paddingAfter; idx++) {
                randomView.setUint8(idx, Math.random()*256)
            }
            outFile.write(randomArray)
            Hash.addData(randomArray) // bootstrap data (random padding) used to calculate hash
        }
        /* Add image Hash to boostrap image */
        var imageHash = Hash.result()
        outFile.write(imageHash)

        outFile.close();
    }

    /*!
        \qmlmethod void Device::parseBootstrapImage(string fileName)
        \brief Parse info from a bootable booststrap image.
    */
    function parseBootstrapImage(fileName)
    {
        var total_size
        var paddingAfter = 0
        var version
        var tableSecuMode = ["No authentication", "AES-CMAC", "RSA", "ECDSA"]
        var tableSecuSteps = ["Single", "Double"]
        
        var file = File.open(fileName, false)
        if (!file)
            throw new Error("Error: Could not read from file '" + fileName + "'")

        total_size = file.size()
        
        if (total_size < bootstrapImageHeaderSize)
            throw new Error("Error: Invalid size")

        var header = file.read(bootstrapImageHeaderSize)
        var headerView = new DataView(header)

        var magic0 = headerView.getUint8(0, true)
        var magic1 = headerView.getUint8(1, true)
        var magic2 = headerView.getUint8(2, true)
        var magic3 = headerView.getUint8(3, true)
        
        var size   = headerView.getUint32(4,true)
        
        var secu_size = headerView.getUint16(8,true)
        
        var secu_mode = headerView.getUint8(11, true)
        
        var secu_algo = (secu_mode>>1) & 0x3
        var secu_steps = (secu_mode>>7) & 0x1
        
        var vers_min =  headerView.getUint16(12,true)
        var vers_maj =  headerView.getUint16(14,true)
        
        print ("Bootstrap image header info:\r\n")
        print ("\t BOOTSTRAP VERSION\t\t= " + vers_maj + "." + vers_min)
        print ("\t MAGIC\t\t\t\t= " + String.fromCharCode(magic0) + String.fromCharCode(magic1) 
        + String.fromCharCode(magic2) + String.fromCharCode(magic3))
        print ("\t SIZE\t\t\t\t= " + Utils.hex(size) + " bytes")
        print ("\t AUTHENTICATION MODE\t\t= " + tableSecuMode[secu_algo])
        if (secu_mode) {
            print("\t SECURITY DATA SIZE\t\t= " + Utils.hex(secu_size) + " bytes")
            print("\t VERIFICATION IMAGE STEPS\t= " + tableSecuSteps[secu_steps])
            
            var txt = "\t HEADER AES-CMAC TAG\t\t= "
            for (var i = 16 ; i < 32; ++i) {
                txt = txt + Utils.hex(headerView.getUint8(i, true), 2, true)
            }
            txt = txt+"\r\n"
            if (secu_steps) {
                txt = txt + "\t CLEAR BOOTSTRAP AES-CMAC TAG\t= "
                for (var i = 32 ; i < bootstrapImageHeaderSize; ++i) {
                    txt = txt + Utils.hex(headerView.getUint8(i, true), 2, true)
                }
                txt = txt+"\r\n"
            }
            print(txt)
        } else {
            var txt = "\t HEADER SHA256 DIGEST\t\t= "
            for (var i = 16 ; i < bootstrapImageHeaderSize; ++i) {
                txt = txt + Utils.hex(headerView.getUint8(i, true), 2, true)
            }
            txt = txt+"\r\n"
            print(txt)
        }
        
    }

    /*! \internal */
    function createBootstrapHeader(size, version)
    {
        // prepare bootstrap header
        // header = MAGIC 4 bytes
        //          size  4 bytes
        //          auth  4 bytes
        //          dual  4 bytes
        //          tag   32 bytes

        var header = new ArrayBuffer(16)
        var headerView = new DataView(header)
        /* Set MAGIC */
        headerView.setUint32(0 /* MAGIC offset */, bootstrapHeaderMagic, true)
        /* Set image size */
        headerView.setUint32(4 /* Image size offset */, size, true)
        /* Set Auth Data : auth security size = 0x20 (hash size 256 bits)*/
        headerView.setUint32(8 /* Auth Data offset */, 0x20, true)
        /* Set Dual Boot Info */
        headerView.setUint32(12 /* Auth Data offset */, version, true)

        /* calculate Hash and append it */
        Hash.reset()
        Hash.addData(header)
        var headerHash = Hash.result()


        return [header,headerHash]
    }

	/*! \internal */
	onConnectionChanged: {
		for (var i = 0; i < applets.length; i++)
			applets[i].connection = connection
	}

	/*! \internal */
	Component.onCompleted: {
		for (var i = 0; i < applets.length; i++)
			applets[i].device = this
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args)	{
		if (args.length > 2)
			return "Invalid number of arguments."

		if (args.length >= 2) {
			if (args[1].length > 0) {
				config.serial.ioset = Utils.parseInteger(args[1]);
				if (isNaN(config.serial.ioset))
					return "Invalid serial console ioset (not a number)."
			}
		}

		if (args.length >= 1) {
			if (args[0].length > 0) {
				config.serial.instance = Utils.parseInteger(args[0]);
				if (isNaN(config.serial.instance))
					return "Invalid serial console instance (not a number)."
			}
		}

		return true;
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: " + name + ":[<instance>]:[<ioset>]",
		        "Parameters:",
		        "    instance   Serial console peripheral number",
		        "    ioset      Serial console I/O set",
		        "Examples:",
		        "    " + name + "       use default device/board settings",
		        "    " + name + ":1:2   use fully custom settings (peripheral number 1, I/O set 2)",
		        "    " + name + "::2    use default device/board settings but force use of I/O set 2",
		        "Note:",
		        "    Peripheral numbers and I/O sets are device specific. Please see device documentation in 'doc' directory."]
	}

	/*! \internal */
	function commandLineSecureCommands() {
		return []
	}

	/*! \internal */
	function commandLineSecureCommandHelp(command) {
		// do nothing
	}

	/*! \internal */
	function commandLineSecureCommand(command, args) {
		// do nothing
	}

	/*! \internal */
	function hasSecureCommand(command) {
		var commands = commandLineSecureCommands()

		return commands.indexOf(command) !== -1
	}

	/*! \internal */
	function strerror(code) {
		// do nothing
	}    

    /*! \internal */
    function isAuthMethodSupported(authMethod) {
        false;
    }
}
