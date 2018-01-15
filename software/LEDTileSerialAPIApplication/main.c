/*
 * main.c
 *
 *  Created on: Jan 10, 2018
 *      Author: Alex
 */
#include <stdio.h>
#include "LEDPanel_Serial_Comm.h"
#include "LEDPanel_Serial_Receiver.h"

void HandleSetPixelCommand(char x, char y, char r, char g, char b);


void HandleSetPixelCommand(char x, char y, char r, char g, char b)
{
	printf("Got set pixel command!");
}


int main()
{

	FILE* fp_usb;
	fp_usb = fopen ("/dev/jtag_uart", "r+");

	init_serial_receiver();

	Handle_SetPixel = &HandleSetPixelCommand;

	while(1)
	{
		char ch;

		ch = getchar();
	  	process_serial_char(ch);
	  	printf("hi");


	}

	return 0;
}
