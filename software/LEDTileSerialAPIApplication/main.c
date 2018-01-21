/*
 * main.c
 *
 *  Created on: Jan 10, 2018
 *      Author: Alex
 */
#include <stdio.h>
#include "LEDPanel_Serial_Comm.h"
#include "LEDPanel_Serial_Receiver.h"
#include "LEDTileLib.h"

void HandleSetPixelCommand(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b);
void print_receiver_status();

void HandleSetPixelCommand(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b)
{
	//printf("%d %d %d %d %d", x, y, r, g, b);
	setPixel(x, y, r, g, b);
}

void print_receiver_status()
{
	printf("Bytes: %d Start: %d Length Received: %d Payload length: %u\n ", receive_status.bytes_received,
										receive_status.is_start_received,
										receive_status.is_length_received,
										receive_status.payload_length);
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

		ch = alt_getchar();
	  	process_serial_char(ch);

	  //	printf("0x%x ", ch);

	}

	return 0;
}
