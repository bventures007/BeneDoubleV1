/*
 * Copyright (c) 2019, Microchip.
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
import SAMBA.Device.SAMA7D65 3.8

/*! \internal */
BootConfigOTPCApplet {
	bcpPacketWords: 20
	uhcpPacketWords: 2
    sbcpPacketWords: 8
    versPacketWords: 3

	/*! \internal */
	function bscrFromText(text) {
		return BSCR.fromText(text)
	}

	/*! \internal */
	function bscrToText(value) {
		return BSCR.toText(value)
	}

	/*! \internal */
	function bcpFromText(text) {
		return BCP.fromText(text)
	}

	/*! \internal */
	function bcpToText(value) {
		return BCP.toText(value)
	}

	/*! \internal */
	function uhcpFromText(text) {
		return UHCP.fromText(text)
	}

	/*! \internal */
	function uhcpToText(value) {
		return UHCP.toText(value)
	}

    /*! \internal */
    function sbcpFromText(text) {
        return SBCP.fromText(text)
    }

    /*! \internal */
    function sbcpToText(value) {
        return SBCP.toText(value)
    }

    /*! \internal */
    function versFromText(text) {
        return VERS.fromText(text)
    }

    /*! \internal */
    function versToText(value) {
        return VERS.toText(value)
    }

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "readcfg") {
			return [" * readcfg - read boot configuration",
				"Syntax:",
				"    readcfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul|sbcp-emul|sbcp-otp|vers-emul|vers-otp|bscr)",
				"Examples:",
				"    readcfg:bcp-otp   read the boot config packet from OTP matrix",
				"    readcfg:bcp-emul  read the boot config packet from OTP emulation mode",
				"    readcfg:uhcp-otp  read the user hardware config packet from OTP matrix",
				"    readcfg:uhcp-emul read the user hardware config packet from OTP emulation mode",
                "    readcfg:sbcp-otp  read the secure boot config packet from OTP matrix",
                "    readcfg:sbcp-emul read the secure boot config packet from OTP emulation mode",
                "    readcfg:vers-otp  read the boot version packet from OTP matrix",
                "    readcfg:vers-emul read the secure boot version packet from OTP emulation mode",
				"    readcfg:bscr      read the boot sequence register (BSCR)"]
		}
		else if (command === "writecfg") {
			return [" * writecfg - write boot configuration",
				"Syntax:",
				"    writecfg:(bcp-otp|bcp-emul):<boot_config_text>",
				"",
				"        <boot_config_text> := [ <global_settings> ] | <global_settings> \",\" <boot_config_text> |",
				"                              [ <boot_sequence> ] | <boot_sequence> \",\" <boot_config_text>",
				"",
				"        <global_settings> := [ <global_setting> ] | <global_setting> \",\" <global_settings>",
				"",
				"        <global_setting> := \"MONITOR_DISABLED\" | \"OTP_PMNGT_DISABLED\" | <console_ioset>",
				"",
				"        <console_ioset> := \"CONSOLE_DISABLED\" | <usart0_entry> | <usart1_entry> | ... | <usart10_entry>",
				"",
				"        <usart0_entry> := \"FLEXCOM0_USART_IOSET1\" | \"FLEXCOM0_USART_IOSET2\"",
				"",
				"        <usart1_entry> := \"FLEXCOM1_USART_IOSET1\" | \"FLEXCOM1_USART_IOSET2\" | \"FLEXCOM1_USART_IOSET3\"",
				"",
				"        <usart2_entry> := \"FLEXCOM2_USART_IOSET1\" | \"FLEXCOM2_USART_IOSET2\" | \"FLEXCOM2_USART_IOSET3\" | \"FLEXCOM2_USART_IOSET4\"",
				"",
				"        <usart3_entry> := \"FLEXCOM3_USART_IOSET1\" | \"FLEXCOM3_USART_IOSET2\" | \"FLEXCOM3_USART_IOSET3\" | \"FLEXCOM3_USART_IOSET4\"",
				"",
				"        <usart4_entry> := \"FLEXCOM4_USART_IOSET1\"",
				"",
				"        <usart5_entry> := \"FLEXCOM5_USART_IOSET1\" | \"FLEXCOM5_USART_IOSET2\"",
				"",
				"        <usart6_entry> := \"FLEXCOM6_USART_IOSET1\" | \"FLEXCOM6_USART_IOSET2\" | \"FLEXCOM6_USART_IOSET3\" | \"FLEXCOM6_USART_IOSET4\"",
				"",
				"        <usart7_entry> := \"FLEXCOM7_USART_IOSET1\" | \"FLEXCOM7_USART_IOSET2\" | \"FLEXCOM7_USART_IOSET3\"",
				"",
				"        <usart8_entry> := \"FLEXCOM8_USART_IOSET1\" | \"FLEXCOM8_USART_IOSET2\" | \"FLEXCOM8_USART_IOSET3\"",
				"",
				"        <usart9_entry> := \"FLEXCOM9_USART_IOSET1\" | \"FLEXCOM9_USART_IOSET2\"",
				"",
				"        <usart10_entry> := \"FLEXCOM10_USART_IOSET1\" | \"FLEXCOM10_USART_IOSET2\"",
				"",
				"        <boot_sequence> := [ <boot_entry> ] | <boot_entry> \",\" <boot_sequence>",
				"",
				"        <boot_entry> := <qspi_entry> | <sdmmc_entry> | <nfc_entry> | <spi_entry> | <spihtol_entry>",
                "",
                "          Note: for each entries described bellow, \"_AR\" is used to enable the Anti Rollback feature",
                "                                                   \"_DB@0x<HEXA_ADDR>\" is used to enable the Dual Boot and to define the bootstrap offset address in memory at 0x<HEXA_ADDR> bytes",
                "                                                   \"_DB@<W><X><Y><Z>\" is used to enable the Dual Boot and to define the name of the bootstrap file \"boot<W><X><Y><Z>.bin (.cip)\" in a FAT32 formatted memory",
                "                for each entries in <nfc_entry> described bellow, \"PMECC0x<HEXA_VAL>\" is used to set the value 0x<HEXA_VAL> for the pmecc config",
                "",
                "        <qspi_entry> := <qspi0_entry> | <qspi1_entry> ",
                "",
                "        <qspi0_entry> := \"QSPI0_IOSET1\" | \"QSPI0_IOSET1_AR\" | \"QSPI0_IOSET1_DB@0x<HEXA_ADDR>\" | \"QSPI0_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <qspi1_entry> := \"QSPI1_IOSET1\" | \"QSPI1_IOSET1_AR\" | \"QSPI1_IOSET1_DB@0x<HEXA_ADDR>\" | \"QSPI1_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <sdmmc_entry> := <sdmmc0_entry> | <sdmmc0_no_cd_entry> | <sdmmc1_entry> | <sdmmc1_no_cd_entry> | <sdmmc2_entry> | <sdmmc2_no_cd_entry>",
                "",
                "        <sdmmc0_entry> := \"SDMMC0_IOSET1\" | \"SDMMC0_IOSET1_AR\" | \"SDMMC0_IOSET1_DB@<W><X><Y><Z>\" | \"SDMMC0_IOSET1_AR_DB@<W><X><Y><Z>\"",
                "",
                "        <sdmmc0_no_cd_entry> := \"SDMMC0_IOSET1_NO_CARD_DETECT\" | \"SDMMC0_IOSET1_NO_CARD_DETECT_AR\" | \"SDMMC0_IOSET1_NO_CARD_DETECT_DB@<W><X><Y><Z>\" | \"SDMMC0_IOSET1_NO_CARD_DETECT_AR_DB@<W><X><Y><Z>\"",
                "",
                "        <sdmmc1_entry> := \"SDMMC1_IOSET1\" | \"SDMMC1_IOSET1_AR\" | \"SDMMC1_IOSET1_DB@<W><X><Y><Z>\" | \"SDMMC1_IOSET1_AR_DB@<W><X><Y><Z>\"",
                "",
                "        <sdmmc1_no_cd_entry> := \"SDMMC1_IOSET1_NO_CARD_DETECT\" | \"SDMMC1_IOSET1_NO_CARD_DETECT_AR\" | \"SDMMC1_IOSET1_NO_CARD_DETECT_DB@<W><X><Y><Z>\" | \"SDMMC1_IOSET1_NO_CARD_DETECT_AR_DB@<W><X><Y><Z>\"",
                "",
                "        <sdmmc2_entry> := \"SDMMC2_IOSET1\" | \"SDMMC2_IOSET1_AR\" | \"SDMMC2_IOSET1_DB@<W><X><Y><Z>\" | \"SDMMC2_IOSET1_AR_DB@<W><X><Y><Z>\"",
                "",
                "        <sdmmc2_no_cd_entry> := \"SDMMC2_IOSET1_NO_CARD_DETECT\" | \"SDMMC2_IOSET1_NO_CARD_DETECT_AR\" | \"SDMMC2_IOSET1_NO_CARD_DETECT_DB@<W><X><Y><Z>\" | \"SDMMC2_IOSET1_NO_CARD_DETECT_AR_DB@<W><X><Y><Z>\"",
                "",
                "        <nfc_entry> := <nfc1_entry> | <nfc2_entry> ",
                "",
                "        <nfc1_entry> := \"NFC_IOSET1_PMECC0x<HEXA_VAL>\" | \"NFC_IOSET1_PMECC0x<HEXA_VAL>_AR\" | \"NFC_IOSET1_PMECC0x<HEXA_VAL>_DB@0x<HEXA_ADDR>\" | \"NFC_IOSET1_PMECC0x<HEXA_VAL>_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <nfc2_entry> := \"NFC_IOSET2_PMECC0x<HEXA_VAL>\" | \"NFC_IOSET2_PMECC0x<HEXA_VAL>_AR\" | \"NFC_IOSET2_PMECC0x<HEXA_VAL>_DB@0x<HEXA_ADDR>\" | \"NFC_IOSET2_PMECC0x<HEXA_VAL>_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi_entry> := <spi0_entry> | <spi1_entry> | ... | <spi26_entry>",
                "",
                "        <spi0_entry> := \"FLEXCOM0_SPI_IOSET1\" | \"FLEXCOM0_SPI_IOSET1_AR\" | \"FLEXCOM0_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM0_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi1_entry> := \"FLEXCOM0_SPI_IOSET2\" | \"FLEXCOM0_SPI_IOSET2_AR\" | \"FLEXCOM0_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM0_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi2_entry> := \"FLEXCOM1_SPI_IOSET1\" | \"FLEXCOM1_SPI_IOSET1_AR\" | \"FLEXCOM1_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM1_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi3_entry> := \"FLEXCOM1_SPI_IOSET2\" | \"FLEXCOM1_SPI_IOSET2_AR\" | \"FLEXCOM1_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM1_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi4_entry> := \"FLEXCOM1_SPI_IOSET3\" | \"FLEXCOM1_SPI_IOSET3_AR\" | \"FLEXCOM1_SPI_IOSET3_DB@0x<HEXA_ADDR>\" | \"FLEXCOM1_SPI_IOSET3_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi5_entry> := \"FLEXCOM2_SPI_IOSET1\" | \"FLEXCOM2_SPI_IOSET1_AR\" | \"FLEXCOM2_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM2_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi6_entry> := \"FLEXCOM2_SPI_IOSET2\" | \"FLEXCOM2_SPI_IOSET2_AR\" | \"FLEXCOM2_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM2_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi7_entry> := \"FLEXCOM2_SPI_IOSET3\" | \"FLEXCOM2_SPI_IOSET3_AR\" | \"FLEXCOM2_SPI_IOSET3_DB@0x<HEXA_ADDR>\" | \"FLEXCOM2_SPI_IOSET3_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi8_entry> := \"FLEXCOM3_SPI_IOSET1\" | \"FLEXCOM3_SPI_IOSET1_AR\" | \"FLEXCOM3_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM3_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi9_entry> := \"FLEXCOM3_SPI_IOSET2\" | \"FLEXCOM3_SPI_IOSET2_AR\" | \"FLEXCOM3_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM3_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi10_entry> := \"FLEXCOM3_SPI_IOSET3\" | \"FLEXCOM3_SPI_IOSET3_AR\" | \"FLEXCOM3_SPI_IOSET3_DB@0x<HEXA_ADDR>\" | \"FLEXCOM3_SPI_IOSET3_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi11_entry> := \"FLEXCOM4_SPI_IOSET1\" | \"FLEXCOM4_SPI_IOSET1_AR\" | \"FLEXCOM4_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM4_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi12_entry> := \"FLEXCOM5_SPI_IOSET1\" | \"FLEXCOM5_SPI_IOSET1_AR\" | \"FLEXCOM5_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM5_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi13_entry> := \"FLEXCOM5_SPI_IOSET2\" | \"FLEXCOM5_SPI_IOSET2_AR\" | \"FLEXCOM5_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM5_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi14_entry> := \"FLEXCOM6_SPI_IOSET1\" | \"FLEXCOM6_SPI_IOSET1_AR\" | \"FLEXCOM6_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM6_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi15_entry> := \"FLEXCOM6_SPI_IOSET2\" | \"FLEXCOM6_SPI_IOSET2_AR\" | \"FLEXCOM6_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM6_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi16_entry> := \"FLEXCOM6_SPI_IOSET3\" | \"FLEXCOM6_SPI_IOSET3_AR\" | \"FLEXCOM6_SPI_IOSET3_DB@0x<HEXA_ADDR>\" | \"FLEXCOM6_SPI_IOSET3_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi17_entry> := \"FLEXCOM6_SPI_IOSET4\" | \"FLEXCOM6_SPI_IOSET4_AR\" | \"FLEXCOM6_SPI_IOSET4_DB@0x<HEXA_ADDR>\" | \"FLEXCOM6_SPI_IOSET4_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi18_entry> := \"FLEXCOM7_SPI_IOSET1\" | \"FLEXCOM7_SPI_IOSET1_AR\" | \"FLEXCOM7_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM7_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi19_entry> := \"FLEXCOM7_SPI_IOSET2\" | \"FLEXCOM7_SPI_IOSET2_AR\" | \"FLEXCOM7_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM7_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi20_entry> := \"FLEXCOM7_SPI_IOSET3\" | \"FLEXCOM7_SPI_IOSET3_AR\" | \"FLEXCOM7_SPI_IOSET3_DB@0x<HEXA_ADDR>\" | \"FLEXCOM7_SPI_IOSET3_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi21_entry> := \"FLEXCOM8_SPI_IOSET1\" | \"FLEXCOM8_SPI_IOSET1_AR\" | \"FLEXCOM8_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM8_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi22_entry> := \"FLEXCOM8_SPI_IOSET2\" | \"FLEXCOM8_SPI_IOSET2_AR\" | \"FLEXCOM8_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM8_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi23_entry> := \"FLEXCOM9_SPI_IOSET1\" | \"FLEXCOM9_SPI_IOSET1_AR\" | \"FLEXCOM9_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM9_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi24_entry> := \"FLEXCOM9_SPI_IOSET2\" | \"FLEXCOM9_SPI_IOSET2_AR\" | \"FLEXCOM9_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM9_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi25_entry> := \"FLEXCOM10_SPI_IOSET1\" | \"FLEXCOM10_SPI_IOSET1_AR\" | \"FLEXCOM10_SPI_IOSET1_DB@0x<HEXA_ADDR>\" | \"FLEXCOM10_SPI_IOSET1_AR_DB@0x<HEXA_ADDR>\"",
                "",
                "        <spi26_entry> := \"FLEXCOM10_SPI_IOSET2\" | \"FLEXCOM10_SPI_IOSET2_AR\" | \"FLEXCOM10_SPI_IOSET2_DB@0x<HEXA_ADDR>\" | \"FLEXCOM10_SPI_IOSET2_AR_DB@0x<HEXA_ADDR>\"",
                "",
				"",
				"    writecfg:(uhcp-otp|uhcp-emul):<user_hw_config_text>",
				"",
				"        <user_hw_config_text> := [ <user_hw_setting> ] | <user_hw_setting> \",\" <user_hw_config_text>",
				"",
				"        <user_hw_setting> := \"JTAGDIS\" | \"SECDBG\" | \"URDDIS\" | \"UPGDIS\" | \"URFDIS\" |",
				"                             \"UHCINVDIS\" | \"UHCLKDIS\" | \"UHCPGDIS\" |",
				"                             \"BCINVDIS\" | \"BCLKDIS\" | \"BCPGDIS\" |",
				"                             \"SBCINVDIS\" | \"SBCLKDIS\" | \"SBCPGDIS\" |",
				"                             \"CINVDIS\" | \"CLKDIS\" | \"CPGDIS\" |",
				"                             \"SCINVDIS\" | \"SCLKDIS\" | \"SCPGDIS\"",
				"",
				"",
                "    writecfg:(vers-otp|vers-emul):<boot_version_text>",
                "",
                "        <boot_version_text> := <nvm_entry> \",\" <major_vers> \",\" <minor_vers> ",
                "",
                "",
                "        <nvm_entry> := <qspi_entry> | <sdmmc_entry> | <nfc_entry> | <spi_entry>",
                "",
                "           <qspi_entry> := \"QSPI0_IOSET1\" | \"QSPI1_IOSET1\"",
                "",
                "           <sdmmc_entry> := \"SDMMC0_IOSET1\" | \"SDMMC1_IOSET1\" | \"SDMMC2_IOSET1\"",
                "",
                "           <nfc_entry> := \"NFC_IOSET1\" | \"NFC_IOSET2\"",
                "",
                "           <spi_entry> := <spi0_entry> | <spi1_entry> | ... | <spi10_entry>",
                "",
                "               <spi0_entry> := \"FLEXCOM0_SPI_IOSET1\" | \"FLEXCOM0_SPI_IOSET2\"",
                "",
                "               <spi1_entry> := \"FLEXCOM1_SPI_IOSET1\" | \"FLEXCOM1_SPI_IOSET2\" | \"FLEXCOM1_SPI_IOSET3\"",
                "",
                "               <spi2_entry> := \"FLEXCOM2_SPI_IOSET1\" | \"FLEXCOM2_SPI_IOSET2\" | \"FLEXCOM2_SPI_IOSET3\"",
                "",
                "               <spi3_entry> := \"FLEXCOM3_SPI_IOSET1\" | \"FLEXCOM3_SPI_IOSET2\" | \"FLEXCOM3_SPI_IOSET3\"",
                "",
                "               <spi4_entry> := \"FLEXCOM4_SPI_IOSET1\"",
                "",
                "               <spi5_entry> := \"FLEXCOM5_SPI_IOSET1\" | \"FLEXCOM5_SPI_IOSET2\"",
                "",
                "               <spi6_entry> := \"FLEXCOM6_SPI_IOSET1\" | \"FLEXCOM6_SPI_IOSET2\" | \"FLEXCOM6_SPI_IOSET3\" | \"FLEXCOM6_SPI_IOSET4\"",
                "",
                "               <spi7_entry> := \"FLEXCOM7_SPI_IOSET1\" | \"FLEXCOM7_SPI_IOSET2\" | \"FLEXCOM7_SPI_IOSET3\"",
                "",
                "               <spi8_entry> := \"FLEXCOM8_SPI_IOSET1\" | \"FLEXCOM8_SPI_IOSET2\"",
                "",
                "               <spi9_entry> := \"FLEXCOM9_SPI_IOSET1\" | \"FLEXCOM9_SPI_IOSET2\"",
                "",
                "               <spi10_entry> := \"FLEXCOM10_SPI_IOSET1\" | \"FLEXCOM10_SPI_IOSET2\"",
                "",
                "",
                "        <major_vers> := integer value",
                "",
                "        <minor_vers> := integer value",
                "",
				"    writecfg:(sbcp-otp|sbcp-emul):",
				"",
				"",
				"    writecfg:bscr:<bscr_emul_value> \",\" <bscr_securam_prot_value>",
				"",
				"        <bscr_emul_value> := \"EMULATION_DISABLED\" | \"EMULATION_ENABLED\"",
                "",
                "        <bscr_securam_prot_value> := \"OTP_PACKETS_COPY_IN_SECURAM_DISABLED\" | \"OTP_PACKETS_COPY_IN_SECURAM_ENABLED\"",
				"",
				"",
				"Examples:",
				"    writecfg:bscr:EMULATION_ENABLED,OTP_PACKETS_COPY_IN_SECURAM_DISABLED enable OTP emulation mode, copy of OTP packets in SECURAM is not done",
				"    writecfg:bscr:EMULATION_DISABLED,OTP_PACKETS_COPY_IN_SECURAM_ENABLED disable OTP emulation mode, copy of OTP packets in SECURAM is done",
				"    writecfg:bcp-emul:FLEXCOM0_USART_IOSET1                              empty boot config (console on FLEXCOM0) stored in OTP emulation mode",
                "    writecfg:bcp-otp:FLEXCOM0_USART_IOSET1,SDMMC1_IOSET1_AR_DB@_2nd      boot config with console on FLEXCOM0, boot from SDMMC1 (Dual boot with bootstrap file named boot_2nd.bin + Anti Rollback) stored in OTP matrix",
                "    writecfg:vers-otp:SDMMC1_IOSET1,14,5                                 boot version packet stored in OTP matrix: version 14.5 concerning SDMMC1",
				"    writecfg:sbcp-emul:                                                  empty secure boot config stored in OTP emulation mode",
				"    writecfg:sbcp-otp:                                                   empty secure boot config stored in OTP matrix"]
		}
		else if (command === "invalidatecfg") {
			return ["* invalidatecfg - invalidate the boot config packet",
				"Syntax:",
				"    invalidatecfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul|sbcp-otp|sbcp-emul)",
				"Examples:",
				"    invalidatecfg:bcp-otp   invalidate the boot config packet in OTP matrix",
				"    invalidatecfg:bcp-emul  invalidate the boot config packet in OTP emulation mode",
				"    invalidatecfg:uhcp-otp  invalidate the user hardware config packet in OTP matrix",
				"    invalidatecfg:uhcp-emul invalidate the user hardware config packet in OTP emulation mode",
				"    invalidatecfg:sbcp-otp  invalidate the secure boot config packet in OTP matrix",
				"    invalidatecfg:sbcp-emul invalidate the secure boot config packet in OTP emulation mode"]
		}
		else if (command === "lockpkt") {
			return ["* lockpkt - lock the boot config packet",
				"Syntax:",
				"    lockpkt:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul|sbcp-top|sbcp-emul)",
				"Examples:",
				"    lockpkt:bcp-otp   lock the boot config packet in OTP matrix",
				"    lockpkt:bcp-emul  lock the boot config packet in OTP emulation mode",
				"    lockpkt:uhcp-otp  lock the user hardware config packet in OTP matrix",
				"    lockpkt:uhcp-emul lock the user hardware config packet in OTP emulation mode",
				"    lockpkt:sbcp-otp  lock the secure boot config packet in OTP matrix",
				"    lockpkt:sbcp-emul lock the secure boot config packet in OTP emulation mode"]
		}
		else if (command === "refreshcfg") {
			return ["* refreshcfg - refresh the OTP matrix or emulation mode",
				"Syntax:",
				"    refreshcfg:(otp|emul)",
				"Examples:",
				"    refreshcfg:otp   disable the OTP emulation mode, if needed, then refresh the OTPC",
				"    refreshcfg:emul  enable the OTP emulation mode, if needed, then refresh the OTPC"]
		}
		else if (command === "resetemul") {
			return ["* resetemul - reset the OTPC SRAM used in emulation mode",
				"Syntax:",
				"    resetemul",
				"Example:",
				"    resetemul  reset the internal SRAM used by the OTPC in emulation mode"]
		}
	}
}
