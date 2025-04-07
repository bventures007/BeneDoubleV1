# SAMA7D65 QSPIFlash Example

Sample scripts to flash a linux environment on QSPIFlash of the
"SAMA7D65 Curiosity Board".

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Plug a USB cable between your PC and the "USB Device" connector of the board
- Power-on or reset the board
- Run the qml script using the sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x qspiflash-usb.qml
    On Linux:
        ../../../sam-ba -x qspiflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Plug your J-Link adapter to the JTAG header
- Power-on the board
- Run the qml script using the sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x qspiflash-jlink.qml
    On Linux:
        ../../../sam-ba -x qspiflash-jlink.qml

## Command Line

Aternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the qspiflash-usb.qml script:

        sam-ba -p serial -b sama7d65-curiosity -a qspiflash -c erase
        sam-ba -p serial -b sama7d65-curiosity -a qspiflash -c writeboot:at91bootstrap.img
        sam-ba -p serial -b sama7d65-curiosity -a qspiflash -c write:u-boot.bin:0x40000
        sam-ba -p serial -b sama7d65-curiosity -a qspiflash -c write:u-boot-env.bin:0x240000
        sam-ba -p serial -b sama7d65-curiosity -a qspiflash -c write:sama7d65_curiosity.dtb:0x280000
        sam-ba -p serial -b sama7d65-curiosity -a qspiflash -c write:zImage:0x28C000

The following commands are equivalent to the qspiflash-jlink.qml script:

        sam-ba -p j-link -b sama7d65-curiosity -a qspiflash -c erase
        sam-ba -p j-link -b sama7d65-curiosity -a qspiflash -c writeboot:at91bootstrap.img
        sam-ba -p j-link -b sama7d65-curiosity -a qspiflash -c write:u-boot.bin:0x40000
        sam-ba -p j-link -b sama7d65-curiosity -a qspiflash -c write:u-boot-env.bin:0x240000
        sam-ba -p j-link -b sama7d65-curiosity -a qspiflash -c write:sama7d65_curiosity.dtb:0x280000
        sam-ba -p j-link -b sama7d65-curiosity -a qspiflash -c write:zImage:0x28C000
