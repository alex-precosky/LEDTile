#include <stdio.h>

// purpose of this is to read from the regular UART (uart0) and print
// what it gets from there to the USB serial port (jtag_uart)

int main()
{

	FILE* fp_usb, *fp_uart;
	fp_usb = fopen ("/dev/jtag_uart", "r+");
	//fp_uart = fopen ("/dev/uart0", "r+");
	//fp_uart = fopen ("/dev/fifoed_avalon_uart_0", "r+");






	char buf[15];
	int i = 0;

	while(1)
	{
		char ch;

		//ch = fread(&ch, 1, 1, fp_uart);
		ch = getchar();

			printf("0x%x ", ch);
	}

	return 0;

}

