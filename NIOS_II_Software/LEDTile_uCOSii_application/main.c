#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include "LEDPanel_Serial_Comm.h"
#include "LEDPanel_Serial_Receiver.h"
#include "LEDTileLib.h"
#include "app_cfg.h"
#include "includes.h"
#include "sequenceTask.h"

void HandleSetPixelCommand(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b);
void HandleSetImageCommand(unsigned char* rgb_pixels);
void HandleSetAnimationFrameCommand(uint32_t frame_index, unsigned char* rgb_pixels);
void HandleStartAnimationCommand(uint32_t num_frames, uint16_t delay_ms);
void print_receiver_status();

OS_STK commTaskStk[TASK_STACKSIZE];

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
  printf("Setting frame %u\n", frame_index);
  SequenceLoadImage(rgb_pixels, frame_index);
}

void HandleStartAnimationCommand(uint32_t num_frames, uint16_t delay_ms) {
	printf("Starting animation of %u frames with %u ms delay\n", num_frames, delay_ms);
	SequenceStart(num_frames, delay_ms);
}

void print_receiver_status()
{
	printf("Bytes: %d Start: %d Length Received: %d Payload length: %u\n ", receive_status.bytes_received,
										receive_status.is_start_received,
										receive_status.is_length_received,
										receive_status.payload_length);
}

void commTask(void* pdata)
{
  while (1)
  { 
		char ch;

		int bytesRead = read( 0, serialBuf, 4096 );
		SequenceStop();

		process_serial_chars(serialBuf, bytesRead);
  }
}


int main(void)
{
  FILE* fp_usb;
  fp_usb = fopen ("/dev/jtag_uart", "r+");

  init_serial_receiver();

  Handle_SetPixel = &HandleSetPixelCommand;
  Handle_SetImage = &HandleSetImageCommand;
  Handle_SetAnimationFrame = &HandleSetAnimationFrameCommand;
  Handle_StartAnimation = &HandleStartAnimationCommand;

  blank();

  CreateSequenceTask();

  OSTaskCreateExt(commTask,
                  NULL,
                  (void *)&commTaskStk[TASK_STACKSIZE-1],
				  TASK_PRIORITY_COMM,
				  TASK_PRIORITY_COMM,
				  commTaskStk,
                  TASK_STACKSIZE,
                  NULL,
                  0);

    OSStart();
    return 0;
}
