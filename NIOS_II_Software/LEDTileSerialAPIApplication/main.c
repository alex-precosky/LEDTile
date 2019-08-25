/*
 * main.c
 *
 *  Created on: Jan 10, 2018
 *      Author: Alex
 */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "LEDPanel_Serial_Comm.h"
#include "LEDPanel_Serial_Receiver.h"
#include "LEDTileLib.h"

#define MAX_NUM_FRAMES 1000
#define IMAGE_SIZE 1024*3
unsigned char image_frames[MAX_NUM_FRAMES*IMAGE_SIZE];



void HandleSetPixelCommand(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b);
void HandleSetImageCommand(unsigned char* rgb_pixels);
void HandleSetAnimationFrameCommand(uint32_t frame_index, unsigned char* rgb_pixels);
void HandleStartAnimationCommand(uint32_t num_frames, uint16_t delay_ms);
void print_receiver_status();

void isr_uart0(void* context);

void HandleSetPixelCommand(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b)
{
	setPixel(x, y, r, g, b);
}

void HandleSetImageCommand(unsigned char* rgb_pixels)
{

   int pixel_ptr = 0;
   for(int j =0; j < 32; j++)
	{
	  for(int i = 0; i < 32; i++)
	  {
		unsigned char r = rgb_pixels[pixel_ptr];
		unsigned char g = rgb_pixels[pixel_ptr + 1];
		unsigned char b = rgb_pixels[pixel_ptr + 2];

		setPixel(i, j, r, g, b);

		pixel_ptr += 3;
	  }
	}

}

void HandleSetAnimationFrameCommand(uint32_t frame_index, unsigned char* rgb_pixels) {
  if (frame_index > MAX_NUM_FRAMES)
	 return; // TODO should be able to return an error

  printf("Setting frame %u\n", frame_index);
  memcpy(image_frames + (frame_index * IMAGE_SIZE), rgb_pixels, IMAGE_SIZE);
}

void HandleStartAnimationCommand(uint32_t num_frames, uint16_t delay_ms) {
	printf("Starting animation of %u frames with %u ms delay\n", num_frames, delay_ms);
	for(uint32_t i = 0; i < num_frames; i++) {
		HandleSetImageCommand(image_frames + (i*IMAGE_SIZE));
		usleep((uint32_t)delay_ms << 6);
	}
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

	void *my_context;
//	alt_ic_isr_register(UART0_IRQ_INTERRUPT_CONTROLLER_ID, UART0_IRQ, isr_timer_0, my_context, 0x0);

	Handle_SetPixel = &HandleSetPixelCommand;
	Handle_SetImage = &HandleSetImageCommand;
    Handle_SetAnimationFrame = &HandleSetAnimationFrameCommand;
    Handle_StartAnimation = &HandleStartAnimationCommand;

	blank();

	while(1)
	{
		char ch;

		ch = alt_getchar();
	  	process_serial_char(ch);

	}

	return 0;
}

void isr_uart0(void* context)
{
	;
}
