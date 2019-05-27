#!/bin/sh
#
# This script is to program the FPGA configuration and Nios II software into the
# Terasic DE0 Nano board for the LED tile

#
# Converting SOF file to a .flash file. This contains the FPGA logic
#
sof2flash --input="../FPGA/output_files/LEDTile.sof" --output="../FPGA/flash/LEDTile_epcs_flash_controller.flash" --epcs --verbose 

#
# Programming the .flash file now that it's converted
# base: base address of the flash memory. The .flash file will take care of the correct offsets into this
# sidp: address of the System ID component
#
nios2-flash-programmer "../FPGA/flash/LEDTile_epcs_flash_controller.flash" --base=0x4009000 --epcs --sidp=0x400A0F0 --id=0x0 --accept-bad-sysid --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

#
# Converting ELF File to a .flash file. This contains the software for the Nios II CPU
#
elf2flash --input="../NIOS_II_Software/LEDTileSerialAPIApplication/LEDTileSerialAPIApplication.elf" --output="../FPGA/flash/LEDTileSerialAPIApplication_epcs_flash_controller.flash" --epcs --after="../FPGA/flash/LEDTile_epcs_flash_controller.flash" --verbose 

#
# Programming the .flash file now that it's converted
#
nios2-flash-programmer "../FPGA/flash/LEDTileSerialAPIApplication_epcs_flash_controller.flash" --base=0x4009000 --epcs --sidp=0x400A0F0 --id=0x0 --accept-bad-sysid --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

