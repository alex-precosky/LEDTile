#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting SOF File: C:\Users\Alex\Desktop\LEDTile\LEDTile_Altera\output_files\LEDTile.sof to: "..\flash/LEDTile_epcs_flash_controller.flash"
#
sof2flash --input="C:/Users/Alex/Desktop/LEDTile/LEDTile_Altera/output_files/LEDTile.sof" --output="../flash/LEDTile_epcs_flash_controller.flash" --epcs 

#
# Programming File: "..\flash/LEDTile_epcs_flash_controller.flash" To Device: epcs_flash_controller
#
nios2-flash-programmer "../flash/LEDTile_epcs_flash_controller.flash" --base=0x4009000 --epcs --sidp=0x400A0B0 --id=0x0 --accept-bad-sysid --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-1]' --program 

#
# Converting ELF File: C:\Users\Alex\Desktop\LEDTile\LEDTile_Altera\software\LEDTileRandomizer\LEDTileRandomizer.elf to: "..\flash/LEDTileRandomizer_epcs_flash_controller.flash"
#
elf2flash --input="C:/Users/Alex/Desktop/LEDTile/LEDTile_Altera/software/LEDTileRandomizer/LEDTileRandomizer.elf" --output="../flash/LEDTileRandomizer_epcs_flash_controller.flash" --epcs --after="../flash/LEDTile_epcs_flash_controller.flash" 

#
# Programming File: "..\flash/LEDTileRandomizer_epcs_flash_controller.flash" To Device: epcs_flash_controller
#
nios2-flash-programmer "../flash/LEDTileRandomizer_epcs_flash_controller.flash" --base=0x4009000 --epcs --sidp=0x400A0B0 --id=0x0 --accept-bad-sysid --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-1]' --program --go 
