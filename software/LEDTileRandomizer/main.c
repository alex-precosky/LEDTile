/*
 * main.c
 *
 *  Created on: Mar 14, 2016
 *      Author: Alex
 */

#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "LEDTileLib.h"
#include "Animations.h"
#include <system.h>

#include "altera_avalon_pio_regs.h"
#include "sys/alt_alarm.h"
#include "alt_types.h"

#include "gif_lib.h"

alt_u32 frame_callback (void* context);
int MemoryGIFRead(GifFileType * gifFile, GifByteType * buf, int numBytes);


alt_u32 gMemoryGifBytesRead = 0;
alt_u32 gFrameIndex = 0;
GifFileType* gCurrentGIF = 0;

alt_alarm frameAlarm;	  // When it's time to display the next frame within the current animation



alt_u32 frame_callback (void* context){

	int row, col;
	unsigned int bmp[1024];

	//static int frameIdx = 0;
	int gifErrorCode, slurpReturnCode;

	// What the tick timer should be when it's time to change the animation
	static alt_u32 nextImageTime = 5000;
	static int gifIdx = 0;

	if( alt_nticks() > nextImageTime)
	{
		gifIdx = (gifIdx + 1) % numGIFs;

		DGifCloseFile(gCurrentGIF, &gifErrorCode); gMemoryGifBytesRead = 0;
		gCurrentGIF = DGifOpen(memoryGifs[gifIdx], MemoryGIFRead, &gifErrorCode);
		slurpReturnCode = DGifSlurp(gCurrentGIF);
		printf("DGifOpen error code: %d   Slurp returned: %d \n", gifErrorCode, slurpReturnCode);

		nextImageTime += 2000;
	}


	for( row = 0; row < 32; row++)
	{
		for(col = 0; col < 32; col++ )
		{
			GifColorType c = gCurrentGIF->SColorMap->Colors[ gCurrentGIF->SavedImages[gFrameIndex].RasterBits[col + 32*row] ];
			unsigned short r = c.Red;
			unsigned short g = c.Green;
			unsigned short b = c.Blue;

		    unsigned int rgb = ((b << 16) ) | ((g << 8) ) | (r );

			bmp[row + 32*col] = rgb;
		}
	}


	displayBitmap(bmp);

	gFrameIndex = (gFrameIndex + 1) % gCurrentGIF->ImageCount;

	return 100;

};


int MemoryGIFRead(GifFileType * gifFile, GifByteType * buf, int numBytes)
{
	MemoryGif *memGif = (MemoryGif*)gifFile->UserData;

	int bytesRemaining = memGif->numBytes - gMemoryGifBytesRead;
	int bytesRead = 0;

	if( numBytes > bytesRemaining)
		bytesRead = bytesRemaining;
	else
		bytesRead = numBytes;

	memcpy((void*)buf, &(memGif->bytes[0]) + gMemoryGifBytesRead, bytesRead);
	gMemoryGifBytesRead += bytesRead;

	return bytesRead;
}



int main()
{

	// clear the control port. bit 0 is just write enable of video buffer
	IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

	int gifErrorCode = 0;
	gMemoryGifBytesRead = 0;

	displayColourBars();

	gCurrentGIF = DGifOpen(memoryGifs[0], MemoryGIFRead, &gifErrorCode); // first arg is a pointer to some user data, which will be found at gifFile->UserData



	printf("DGifOpen error code: %d\n", gifErrorCode);
	gifErrorCode = DGifSlurp(gCurrentGIF);
	printf("DGifSlurp error code: %d\n", gifErrorCode);


	if(gifErrorCode != GIF_OK)
	{
		printf("Slurp error: %d\n" , gCurrentGIF->Error);
		DGifCloseFile(gCurrentGIF, &gifErrorCode);

	}


	// Alarm for updating the frame of animation within a GIF
	  alt_alarm_start (&frameAlarm,
			  100,
			  frame_callback,
			  NULL);

	  while(true)
		  ;

	return 0;
}
