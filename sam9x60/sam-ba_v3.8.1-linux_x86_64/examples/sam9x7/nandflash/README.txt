# SAM9X7 NANDFlash Example

Sample scripts to flash a linux environment on NANDFlash of the
"SAM9X75 Curiosity Board".

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Plug a USB cable between your PC and the "USB Device" connector of the board
- Power-on or reset the board
- Run the qml script using the sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x nandflash-usb.qml
    On Linux:
        ../../../sam-ba -x nandflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Plug your J-Link adapter to the JTAG header
- Power-on the board
- Run the qml script using the sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x nandflash-jlink.qml
    On Linux:
        ../../../sam-ba -x nandflash-jlink.qml

## Command Line

Aternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the nandflash-usb.qml script:

        sam-ba -p serial -b sam9x75-curiosity -a nandflash -c erase
        sam-ba -p serial -b sam9x75-curiosity -a nandflash -c writeboot:at91bootstrap.img
        sam-ba -p serial -b sam9x75-curiosity -a nandflash -c write:u-boot.bin:0x40000
        sam-ba -p serial -b sam9x75-curiosity -a nandflash -c write:u-boot-env.bin:0x240000
        sam-ba -p serial -b sam9x75-curiosity -a nandflash -c write:sama7d65_curiosity.dtb:0x280000
        sam-ba -p serial -b sam9x75-curiosity -a nandflash -c write:zImage:0x28C000

The following commands are equivalent to the nandflash-jlink.qml script:

        sam-ba -p j-link -b sam9x75-curiosity -a nandflash -c erase
        sam-ba -p j-link -b sam9x75-curiosity -a nandflash -c writeboot:at91bootstrap.img
        sam-ba -p j-link -b sam9x75-curiosity -a nandflash -c write:u-boot.bin:0x40000
        sam-ba -p j-link -b sam9x75-curiosity -a nandflash -c write:u-boot-env.bin:0x240000
        sam-ba -p j-link -b sam9x75-curiosity -a nandflash -c write:sama7d65_curiosity.dtb:0x280000
        sam-ba -p j-link -b sam9x75-curiosity -a nandflash -c write:zImage:0x28C000
