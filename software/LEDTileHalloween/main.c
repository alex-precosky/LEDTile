/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include <system.h>
#include "altera_avalon_pio_regs.h"
#include "sys/alt_alarm.h"
#include "alt_types.h"

#include "LEDTileLib.h"

#include "Animations.h"

void delay();
void longDelay();
alt_u32 frame_callback (void* context);



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





const int numBitmaps = 13;





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

	displayBitmap(myAnimation->frames[i]);

	i = (i + 1) % myAnimation->numFrames;

	return myAnimation->millisecondInterval;

};







int main()
{

  blank();
  printf("Hello from LED Tile!\n");
  delay();

  currentAnimation = animations[1];




  alt_alarm_start (&alarm,
		  1000,
		  frame_callback,
		  NULL);

  while(1)
	  {
	  	  char ch;

	  	  ch = getchar();
	  	  printf("%c", ch);


	  	  if(ch == '0') // mosaic
	  		  currentAnimation = halloweenAnimations[0];
	  	  else if(ch == '1') // ie
	  		  currentAnimation = halloweenAnimations[1];
	  	  else // netscape
	  		  currentAnimation = halloweenAnimations[2];

	  }

  return 0;
}





