#include <stdio.h>

// purpose of this is to read from the regular UART (uart0) and print
// what it gets from there to the USB serial port (jtag_uart)

int main()
{

	FILE* fp_usb, *fp_uart;
	fp_usb = fopen ("/dev/jtag_uart", "r+");

	while(1)
	{
		char ch;

		ch = getchar();
	  	fwrite(&ch, sizeof(char), 1, fp_usb);
	}

	return 0;
}

