/*
 * main.c
 *
 *  Created on: Apr 14, 2015
 *      Author: Alex
 */



#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include <system.h>
#include "altera_avalon_pio_regs.h"
#include "sys/alt_alarm.h"
#include "alt_types.h"

#include "Animations.h"

#include "LEDTileLib.h"

void delay();
void longDelay();

alt_u32 frame_callback (void* context);


void printMenu();

// Custom read function for giflib
//int MemoryGIFRead(GifFileType * gifFile, GifByteType * buf, int numBytes);

typedef struct memGifFiles {
	const unsigned char* gifBytes;
	unsigned int length;
	unsigned int bytesRead;
} memGifFile;

#define STATE_ANIMATION 0
#define STATE_BLANK 1

int state = STATE_ANIMATION;
AnimatedImage *currentAnimation; // must be initialized

static alt_alarm alarm;



/*
const unsigned char kainGifBytes[1435] = {
			0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x20, 0x00, 0x20, 0x00, 0xF7, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x33, 0x00, 0x00, 0x66, 0x00, 0x00,
			0x99, 0x00, 0x00, 0xCC, 0x00, 0x00, 0xFF, 0x00, 0x2B, 0x00, 0x00, 0x2B,
			0x33, 0x00, 0x2B, 0x66, 0x00, 0x2B, 0x99, 0x00, 0x2B, 0xCC, 0x00, 0x2B,
			0xFF, 0x00, 0x55, 0x00, 0x00, 0x55, 0x33, 0x00, 0x55, 0x66, 0x00, 0x55,
			0x99, 0x00, 0x55, 0xCC, 0x00, 0x55, 0xFF, 0x00, 0x80, 0x00, 0x00, 0x80,
			0x33, 0x00, 0x80, 0x66, 0x00, 0x80, 0x99, 0x00, 0x80, 0xCC, 0x00, 0x80,
			0xFF, 0x00, 0xAA, 0x00, 0x00, 0xAA, 0x33, 0x00, 0xAA, 0x66, 0x00, 0xAA,
			0x99, 0x00, 0xAA, 0xCC, 0x00, 0xAA, 0xFF, 0x00, 0xD5, 0x00, 0x00, 0xD5,
			0x33, 0x00, 0xD5, 0x66, 0x00, 0xD5, 0x99, 0x00, 0xD5, 0xCC, 0x00, 0xD5,
			0xFF, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x33, 0x00, 0xFF, 0x66, 0x00, 0xFF,
			0x99, 0x00, 0xFF, 0xCC, 0x00, 0xFF, 0xFF, 0x33, 0x00, 0x00, 0x33, 0x00,
			0x33, 0x33, 0x00, 0x66, 0x33, 0x00, 0x99, 0x33, 0x00, 0xCC, 0x33, 0x00,
			0xFF, 0x33, 0x2B, 0x00, 0x33, 0x2B, 0x33, 0x33, 0x2B, 0x66, 0x33, 0x2B,
			0x99, 0x33, 0x2B, 0xCC, 0x33, 0x2B, 0xFF, 0x33, 0x55, 0x00, 0x33, 0x55,
			0x33, 0x33, 0x55, 0x66, 0x33, 0x55, 0x99, 0x33, 0x55, 0xCC, 0x33, 0x55,
			0xFF, 0x33, 0x80, 0x00, 0x33, 0x80, 0x33, 0x33, 0x80, 0x66, 0x33, 0x80,
			0x99, 0x33, 0x80, 0xCC, 0x33, 0x80, 0xFF, 0x33, 0xAA, 0x00, 0x33, 0xAA,
			0x33, 0x33, 0xAA, 0x66, 0x33, 0xAA, 0x99, 0x33, 0xAA, 0xCC, 0x33, 0xAA,
			0xFF, 0x33, 0xD5, 0x00, 0x33, 0xD5, 0x33, 0x33, 0xD5, 0x66, 0x33, 0xD5,
			0x99, 0x33, 0xD5, 0xCC, 0x33, 0xD5, 0xFF, 0x33, 0xFF, 0x00, 0x33, 0xFF,
			0x33, 0x33, 0xFF, 0x66, 0x33, 0xFF, 0x99, 0x33, 0xFF, 0xCC, 0x33, 0xFF,
			0xFF, 0x66, 0x00, 0x00, 0x66, 0x00, 0x33, 0x66, 0x00, 0x66, 0x66, 0x00,
			0x99, 0x66, 0x00, 0xCC, 0x66, 0x00, 0xFF, 0x66, 0x2B, 0x00, 0x66, 0x2B,
			0x33, 0x66, 0x2B, 0x66, 0x66, 0x2B, 0x99, 0x66, 0x2B, 0xCC, 0x66, 0x2B,
			0xFF, 0x66, 0x55, 0x00, 0x66, 0x55, 0x33, 0x66, 0x55, 0x66, 0x66, 0x55,
			0x99, 0x66, 0x55, 0xCC, 0x66, 0x55, 0xFF, 0x66, 0x80, 0x00, 0x66, 0x80,
			0x33, 0x66, 0x80, 0x66, 0x66, 0x80, 0x99, 0x66, 0x80, 0xCC, 0x66, 0x80,
			0xFF, 0x66, 0xAA, 0x00, 0x66, 0xAA, 0x33, 0x66, 0xAA, 0x66, 0x66, 0xAA,
			0x99, 0x66, 0xAA, 0xCC, 0x66, 0xAA, 0xFF, 0x66, 0xD5, 0x00, 0x66, 0xD5,
			0x33, 0x66, 0xD5, 0x66, 0x66, 0xD5, 0x99, 0x66, 0xD5, 0xCC, 0x66, 0xD5,
			0xFF, 0x66, 0xFF, 0x00, 0x66, 0xFF, 0x33, 0x66, 0xFF, 0x66, 0x66, 0xFF,
			0x99, 0x66, 0xFF, 0xCC, 0x66, 0xFF, 0xFF, 0x99, 0x00, 0x00, 0x99, 0x00,
			0x33, 0x99, 0x00, 0x66, 0x99, 0x00, 0x99, 0x99, 0x00, 0xCC, 0x99, 0x00,
			0xFF, 0x99, 0x2B, 0x00, 0x99, 0x2B, 0x33, 0x99, 0x2B, 0x66, 0x99, 0x2B,
			0x99, 0x99, 0x2B, 0xCC, 0x99, 0x2B, 0xFF, 0x99, 0x55, 0x00, 0x99, 0x55,
			0x33, 0x99, 0x55, 0x66, 0x99, 0x55, 0x99, 0x99, 0x55, 0xCC, 0x99, 0x55,
			0xFF, 0x99, 0x80, 0x00, 0x99, 0x80, 0x33, 0x99, 0x80, 0x66, 0x99, 0x80,
			0x99, 0x99, 0x80, 0xCC, 0x99, 0x80, 0xFF, 0x99, 0xAA, 0x00, 0x99, 0xAA,
			0x33, 0x99, 0xAA, 0x66, 0x99, 0xAA, 0x99, 0x99, 0xAA, 0xCC, 0x99, 0xAA,
			0xFF, 0x99, 0xD5, 0x00, 0x99, 0xD5, 0x33, 0x99, 0xD5, 0x66, 0x99, 0xD5,
			0x99, 0x99, 0xD5, 0xCC, 0x99, 0xD5, 0xFF, 0x99, 0xFF, 0x00, 0x99, 0xFF,
			0x33, 0x99, 0xFF, 0x66, 0x99, 0xFF, 0x99, 0x99, 0xFF, 0xCC, 0x99, 0xFF,
			0xFF, 0xCC, 0x00, 0x00, 0xCC, 0x00, 0x33, 0xCC, 0x00, 0x66, 0xCC, 0x00,
			0x99, 0xCC, 0x00, 0xCC, 0xCC, 0x00, 0xFF, 0xCC, 0x2B, 0x00, 0xCC, 0x2B,
			0x33, 0xCC, 0x2B, 0x66, 0xCC, 0x2B, 0x99, 0xCC, 0x2B, 0xCC, 0xCC, 0x2B,
			0xFF, 0xCC, 0x55, 0x00, 0xCC, 0x55, 0x33, 0xCC, 0x55, 0x66, 0xCC, 0x55,
			0x99, 0xCC, 0x55, 0xCC, 0xCC, 0x55, 0xFF, 0xCC, 0x80, 0x00, 0xCC, 0x80,
			0x33, 0xCC, 0x80, 0x66, 0xCC, 0x80, 0x99, 0xCC, 0x80, 0xCC, 0xCC, 0x80,
			0xFF, 0xCC, 0xAA, 0x00, 0xCC, 0xAA, 0x33, 0xCC, 0xAA, 0x66, 0xCC, 0xAA,
			0x99, 0xCC, 0xAA, 0xCC, 0xCC, 0xAA, 0xFF, 0xCC, 0xD5, 0x00, 0xCC, 0xD5,
			0x33, 0xCC, 0xD5, 0x66, 0xCC, 0xD5, 0x99, 0xCC, 0xD5, 0xCC, 0xCC, 0xD5,
			0xFF, 0xCC, 0xFF, 0x00, 0xCC, 0xFF, 0x33, 0xCC, 0xFF, 0x66, 0xCC, 0xFF,
			0x99, 0xCC, 0xFF, 0xCC, 0xCC, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0xFF, 0x00,
			0x33, 0xFF, 0x00, 0x66, 0xFF, 0x00, 0x99, 0xFF, 0x00, 0xCC, 0xFF, 0x00,
			0xFF, 0xFF, 0x2B, 0x00, 0xFF, 0x2B, 0x33, 0xFF, 0x2B, 0x66, 0xFF, 0x2B,
			0x99, 0xFF, 0x2B, 0xCC, 0xFF, 0x2B, 0xFF, 0xFF, 0x55, 0x00, 0xFF, 0x55,
			0x33, 0xFF, 0x55, 0x66, 0xFF, 0x55, 0x99, 0xFF, 0x55, 0xCC, 0xFF, 0x55,
			0xFF, 0xFF, 0x80, 0x00, 0xFF, 0x80, 0x33, 0xFF, 0x80, 0x66, 0xFF, 0x80,
			0x99, 0xFF, 0x80, 0xCC, 0xFF, 0x80, 0xFF, 0xFF, 0xAA, 0x00, 0xFF, 0xAA,
			0x33, 0xFF, 0xAA, 0x66, 0xFF, 0xAA, 0x99, 0xFF, 0xAA, 0xCC, 0xFF, 0xAA,
			0xFF, 0xFF, 0xD5, 0x00, 0xFF, 0xD5, 0x33, 0xFF, 0xD5, 0x66, 0xFF, 0xD5,
			0x99, 0xFF, 0xD5, 0xCC, 0xFF, 0xD5, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF,
			0x33, 0xFF, 0xFF, 0x66, 0xFF, 0xFF, 0x99, 0xFF, 0xFF, 0xCC, 0xFF, 0xFF,
			0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x21, 0xF9, 0x04, 0x01, 0x00, 0x00, 0xFC, 0x00, 0x2C, 0x00, 0x00,
			0x00, 0x00, 0x20, 0x00, 0x20, 0x00, 0x00, 0x08, 0xFF, 0x00, 0x01, 0xA8,
			0x00, 0x40, 0xB0, 0xA0, 0xC1, 0x83, 0x00, 0xE6, 0xCD, 0x53, 0xA1, 0x10,
			0xE1, 0xC0, 0x82, 0x6A, 0x10, 0x12, 0x5C, 0xF3, 0x50, 0xE0, 0x3C, 0x61,
			0x01, 0x22, 0x0E, 0x6B, 0x58, 0x50, 0x07, 0x0C, 0x83, 0x64, 0x1C, 0xC2,
			0x29, 0x38, 0x66, 0x06, 0x80, 0x61, 0x30, 0x22, 0x12, 0xE4, 0xA5, 0x50,
			0x05, 0x90, 0x8A, 0x04, 0x53, 0x4A, 0xA4, 0x68, 0xA0, 0x8B, 0x0C, 0x82,
			0x6A, 0x02, 0x00, 0x68, 0x37, 0x8F, 0x60, 0x8C, 0x97, 0x12, 0x01, 0xAC,
			0x41, 0x18, 0xB1, 0x4B, 0x8E, 0x92, 0x00, 0xD4, 0x54, 0x9C, 0x17, 0x23,
			0xA2, 0x00, 0x8E, 0x05, 0x5D, 0x2A, 0xF5, 0x39, 0x43, 0xCD, 0x51, 0x1D,
			0x63, 0x72, 0x74, 0x01, 0x32, 0xA3, 0xA2, 0xD5, 0x15, 0xF9, 0x82, 0xAA,
			0xD0, 0x61, 0x55, 0x85, 0x8C, 0x31, 0x6A, 0x66, 0x8C, 0x01, 0xA2, 0xA6,
			0x64, 0xDB, 0x1C, 0x00, 0xD0, 0x86, 0x4C, 0x78, 0x10, 0x86, 0xCE, 0xB8,
			0x39, 0xD4, 0xE8, 0x30, 0xAA, 0x26, 0x6D, 0xDF, 0xAA, 0x56, 0xF9, 0xE6,
			0x98, 0xF1, 0x51, 0xA0, 0xC1, 0x15, 0x39, 0x60, 0x08, 0x50, 0xA1, 0xD6,
			0x2A, 0xE0, 0xC7, 0x6A, 0x80, 0x70, 0x21, 0x5B, 0xF2, 0x61, 0xC4, 0x9E,
			0x06, 0xD7, 0xC0, 0x38, 0xA0, 0x22, 0x6F, 0x5B, 0xB2, 0x32, 0xFA, 0x86,
			0x26, 0xE3, 0x79, 0x86, 0x01, 0x15, 0x07, 0x22, 0xB6, 0xA3, 0x6B, 0x50,
			0x0D, 0x8C, 0xAE, 0x64, 0x80, 0xCC, 0xEB, 0x4B, 0x7B, 0x0D, 0xDB, 0xD9,
			0x1E, 0xBB, 0x24, 0x1D, 0x28, 0xCC, 0x21, 0x59, 0xC2, 0x6A, 0x65, 0x93,
			0x55, 0x48, 0x7A, 0xF6, 0xE0, 0xCE, 0x7A, 0x09, 0x62, 0x36, 0x08, 0x43,
			0xC6, 0x3C, 0xC2, 0x32, 0x10, 0xF7, 0x0D, 0x12, 0x9B, 0x76, 0x8E, 0x15,
			0x62, 0x56, 0x38, 0xCF, 0x31, 0x70, 0xB9, 0xC1, 0x00, 0x59, 0xBB, 0xBC,
			0xFF, 0x86, 0x31, 0xBC, 0xEF, 0x3C, 0x20, 0x3A, 0x3A, 0x77, 0xCE, 0xCA,
			0x50, 0xB9, 0x44, 0x31, 0x6A, 0x39, 0x2F, 0xCC, 0xCB, 0x16, 0x08, 0x19,
			0x86, 0x9C, 0xB5, 0x76, 0xDD, 0xC8, 0xFA, 0x60, 0x00, 0x2E, 0x07, 0x8C,
			0x11, 0xC3, 0x46, 0x2A, 0xAC, 0xA1, 0x06, 0x19, 0x11, 0xE5, 0x33, 0xCC,
			0x58, 0xE3, 0x0D, 0x43, 0x97, 0x77, 0x51, 0x79, 0x94, 0xD4, 0x0C, 0xC2,
			0xCC, 0x10, 0x1A, 0x10, 0x25, 0x99, 0x53, 0x15, 0x6A, 0x63, 0x10, 0xB4,
			0x5A, 0x4F, 0x10, 0x02, 0x60, 0xC0, 0x18, 0x2B, 0xC0, 0xB0, 0x82, 0x1A,
			0x5C, 0xCC, 0xD0, 0xC5, 0x5F, 0x29, 0xBA, 0xC6, 0x59, 0x7A, 0xEE, 0x85,
			0xC8, 0x20, 0x61, 0x9C, 0xB1, 0xC5, 0x05, 0x5B, 0x80, 0x19, 0xB0, 0x82,
			0x7A, 0x2A, 0x61, 0x06, 0x61, 0x3E, 0x7A, 0x71, 0x11, 0x80, 0x89, 0xAF,
			0x91, 0x15, 0x18, 0x00, 0x31, 0xC0, 0x50, 0x53, 0x5E, 0x3E, 0x06, 0x35,
			0x0F, 0x3B, 0xE9, 0x0D, 0x63, 0x40, 0x0C, 0x66, 0xF5, 0x05, 0x20, 0x0C,
			0x2A, 0x0C, 0xB3, 0xC2, 0x18, 0xFC, 0x05, 0x65, 0xD0, 0x30, 0x32, 0x98,
			0x78, 0x91, 0x96, 0xC9, 0x75, 0x21, 0x4C, 0x4F, 0xAF, 0x09, 0x03, 0x93,
			0x58, 0x09, 0x8D, 0x91, 0x1E, 0x4F, 0xC2, 0x94, 0xB5, 0x51, 0x80, 0x3A,
			0x2C, 0x74, 0x97, 0x97, 0x01, 0x90, 0x21, 0x0C, 0x58, 0x27, 0x29, 0xD4,
			0x8B, 0x5E, 0x30, 0x28, 0xC4, 0x0B, 0x58, 0x59, 0x72, 0xE7, 0x25, 0x72,
			0x61, 0x51, 0x79, 0x66, 0x4B, 0x31, 0xB0, 0x34, 0xCF, 0x6A, 0x1F, 0xCD,
			0xA6, 0x92, 0x44, 0x06, 0x20, 0xB8, 0x10, 0x67, 0x1B, 0x2D, 0x2A, 0xE8,
			0x45, 0x2B, 0x50, 0x99, 0x8F, 0x0E, 0xDC, 0x71, 0xE6, 0x50, 0x0E, 0xF3,
			0xD4, 0xA9, 0xDE, 0x3C, 0x01, 0xF0, 0xB2, 0xCF, 0x3E, 0x18, 0xCD, 0x97,
			0x10, 0x59, 0x64, 0x18, 0x78, 0x30, 0x19, 0x4C, 0x88, 0x19, 0xD8, 0x50,
			0x17, 0x06, 0xF0, 0x74, 0x51, 0x2F, 0x0A, 0xED, 0x69, 0x62, 0x3E, 0xF3,
			0xE4, 0xC0, 0x9D, 0xB0, 0x6A, 0x50, 0x04, 0x00, 0xAE, 0x79, 0xC9, 0x40,
			0x6A, 0x0C, 0x32, 0xE8, 0xF6, 0x64, 0x00, 0x2A, 0x9C, 0xC9, 0x58, 0xA4,
			0x79, 0xA5, 0xA7, 0x22, 0xA9, 0x3A, 0xE4, 0x03, 0x9B, 0x1A, 0xCF, 0x71,
			0x31, 0xCF, 0x6B, 0x2A, 0x18, 0xA0, 0x90, 0x42, 0x43, 0xC6, 0x90, 0x90,
			0x4D, 0xAE, 0xCD, 0x00, 0xDF, 0x3C, 0xCA, 0xB2, 0x8B, 0x2C, 0xB7, 0xE4,
			0x72, 0x71, 0x1D, 0x2F, 0xC3, 0xD0, 0x0B, 0x83, 0x6E, 0x31, 0x8C, 0xAB,
			0x83, 0x76, 0x36, 0xCD, 0xD3, 0x45, 0xBF, 0x5D, 0xA9, 0x28, 0xC3, 0x0C,
			0x0A, 0xBD, 0xC6, 0x05, 0x95, 0xA8, 0x09, 0x19, 0x28, 0xBB, 0xD0, 0x8D,
			0xE1, 0x9C, 0x85, 0x01, 0x01, 0x00, 0x3B


};

*/







const int numBitmaps = 13;


/*int MemoryGIFRead(GifFileType * gifFile, GifByteType * buf, int numBytes){

	int numBytesActual;
	int numBytesLeft;

int i;

	memGifFile *myMemGifFile = (memGifFile*)gifFile->UserData;

	numBytesLeft = myMemGifFile->length - myMemGifFile->bytesRead;
	if(numBytesLeft < numBytes )
		numBytesActual = numBytesLeft;
	else
		numBytesActual = numBytes;

	memcpy(  buf, myMemGifFile->gifBytes+myMemGifFile->bytesRead, numBytesActual*sizeof(unsigned char) );
//	for( i =0;i < numBytesActual;i++)
//		*(buf+i) = *(myMemGifFile->gifBytes+i+myMemGifFile->bytesRead);

	myMemGifFile->bytesRead += numBytesActual;


	return numBytesActual;
}

*/



void longDelay()
{
	int delay=0;
	while(delay < 3000)
	{
	delay++;
	}

}



alt_u32 frame_callback (void* context){
	static int i = 0;

	AnimatedImage *myAnimation = currentAnimation;

	if(state==STATE_ANIMATION)
		displayBitmap(myAnimation->frames[i]);

	i = (i + 1) % myAnimation->numFrames;

	return myAnimation->millisecondInterval;

};



int main()
{

  //int giflibErr;
  //GifFileType *gifFile;
  //memGifFile kainGif = {kainGifBytes, 1435, 0};

  printf("Hello from LED Tile!\n");
  delay();

  currentAnimation = animations[1];

  // clear the control port. bit 0 is just write enable of video buffer
  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

//  gifFile = DGifOpen(&kainGif, MemoryGIFRead, &giflibErr);
 // giflibErr=DGifSlurp(gifFile);



  alt_alarm_start (&alarm,
		  1000,
		  frame_callback,
		  NULL);

  currentAnimation = halloweenAnimations[0];

  printMenu();

  while(1)
	  {
	  	  int i;

	  	  scanf("%d", &i);
	  	  printf("%d", i);
	  	  fflush(stdin);


	  	  if(i==1)
	  	  {
	  		  animationsMenu();
	  		  state=STATE_ANIMATION;
	  		  printMenu();
	  	  }
	  	  else if(i==2)
	  	  {
	  		state=STATE_BLANK;
	  		blank();
	  		printMenu();
	  	  }
	  	  else if(i==3)
	  	  {
	  		  state=STATE_BLANK;
	  		  displayColourBars();
	  		  printMenu();
	  	  }
	  	  else if(i==4)
	  	  {
	  		  state=STATE_BLANK;
	  		  displayCIEColourBars();
	  		  printMenu();
	  	  }
	  	  else if(i==5)
	  	  {
	  		  state=STATE_BLANK;
	  		  displayGamma149ColourBars();
	  		  printMenu();
	  	  }
	  	  else if(i==6)
	  	  {
	  		  state=STATE_BLANK;
	  		  displayGamma98ColourBars();
	  		  printMenu();
	  	  }
	  	  else if(i==7)
	  	  {
	  		  state=STATE_BLANK;
	  		  displayGamma46ColourBars();
	  		  printMenu();
	  	  }
	  	  else
	  		  printMenu();

	  }



  return 0;
}



void printMenu()
{
	printf("LED Tile Menu\n");
	printf("-------------\n");
	printf("1) Select animation\n");
	printf("2) Blank display\n");
	printf("3) Display RGB value colour bars\n");
	printf("4) Display CIE 1931 corrected RGB colour bars\n");
	printf("5) Display 149-half gamma corrected RGB colour bars\n");
	printf("6) Display 98-half gamma corrected RGB colour bars\n");
	printf("7) Display 46-half gamma corrected RGB colour bars\n\n");
	printf("Enter Selection: ");

}


void animationsMenu()
{
	int i;

	for(i=0; i < numAnimations; i++)
		printf("%i) %s\n", i, animations[i]->description);


	scanf("%d", &i);
	fflush(stdin);

	currentAnimation = animations[i];

}