# LEDTile

A 32x32 LED tile that I hung up on my wall.  Uses a Terasic DE0-Nano FPGA with a Nios II core soft CPU and a custom circuitboard.

![Tile on wall](doc/LEDTile.png)

# Prerequisites

* Quartus Prime 17.1 Lite Edition
* A Terasic DE0-Nano FPGA or something like it
* My circuit or something else to power the board and FPGA and connect them together

# Components

* The DE0-Nano board
  * Logic for pushing a memory pixel buffer to the tile
  * Nios II core CPU for graphics into the pixel buffer
* My custom circuit board the provides a place to hook up the FPGA and LED tile to, and supplies power
* Cables
* On/Off Switch
* 5V DC power jack

The are connected as shown: 
![Wiring Diagram](doc/WiringDiagram.jpg)

### About the Terasic DE0-Nano

Of interest to this project, the board contains...

* Altera Cyclone IV EP4CE22F17C6N
* 32MB SDRAM
* 64Mb EPCS64 serial configuration device
* 50 MHz oscillator
* 72 IO pins
* On-board USB Blaster circuit

# Building

## FPGA Configuration
LEDTile.qpf is the Quartus project file and should be opened in Quartus. It can be build and converted into a programming file then loaded into the serial configuration device over USB.

## Nios II Software
Open the Eclipse tools for Nios II and create a new workspace, and add all of the projects in
/software to it.  Build LEDTileApplication and write it to the serial configuration device.

## ESP8266 Software
This is a Platform IO project built in Visual Studio Code. It can be uploaded by a USB-Serial cable to the board or over WiFi if first loaded with the ESP8266 WiFi loader and configured with the access details for an access point.

# What Happens on Bootup
The FPGA loads its configuration from the EPCS configuration device.  This includes the Nios II soft core CPU and the FPGA logic that reads from a display buffer to update pixels on the display.

The Nios II processor reset address is set to the base address of the EPCS controller in Qsys. At reset, a boot copier program runs on the Nios II from on chip ram, the program skips the FPGA configuration in the EPCS device, then reads the data following it into the SDRAM, then jumps to the start of the program.  The boot copier is put there by Quartus.
