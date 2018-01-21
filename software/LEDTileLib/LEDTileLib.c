#include "LEDTileLib.h"

#include <system.h>
#include "altera_avalon_pio_regs.h"

/* Look up table conversion from RGB to LED tile colours
 *
 * Each R, G, and B value, as displayed by the tile, is represented by 48-bits-per-pixel
 *
 * But, bitmaps are stored as 24-bpp RGB.   A few possible lookuptables are available
 * Generally, gamma46half looked the best
 */

const unsigned short linearRGB [256] = {
		0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144, 148, 152, 156, 160, 164, 168, 173, 177, 181, 185, 189, 193, 197, 201, 205, 209, 213, 217, 221, 225, 229, 233, 237, 241, 245, 249, 253, 257, 261, 265, 269, 273, 277, 281, 285, 289, 293, 297, 301, 305, 309, 313, 317, 321, 325, 329, 333, 337, 341, 345, 349, 353, 357, 361, 365, 369, 373, 377, 381, 385, 389, 393, 397, 401, 405, 409, 413, 417, 421, 425, 429, 433, 437, 441, 445, 449, 453, 457, 461, 465, 469, 473, 477, 481, 485, 489, 493, 497, 501, 505, 509, 514, 518, 522, 526, 530, 534, 538, 542, 546, 550, 554, 558, 562, 566, 570, 574, 578, 582, 586, 590, 594, 598, 602, 606, 610, 614, 618, 622, 626, 630, 634, 638, 642, 646, 650, 654, 658, 662, 666, 670, 674, 678, 682, 686, 690, 694, 698, 702, 706, 710, 714, 718, 722, 726, 730, 734, 738, 742, 746, 750, 754, 758, 762, 766, 770, 774, 778, 782, 786, 790, 794, 798, 802, 806, 810, 814, 818, 822, 826, 830, 834, 838, 842, 846, 850, 855, 859, 863, 867, 871, 875, 879, 883, 887, 891, 895, 899, 903, 907, 911, 915, 919, 923, 927, 931, 935, 939, 943, 947, 951, 955, 959, 963, 967, 971, 975, 979, 983, 987, 991, 995, 999, 1003, 1007, 1011, 1015, 1019, 1023
};

const unsigned short cie1931 [256] = {
		0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 15, 15, 16, 17, 17, 18, 19, 19, 20, 21, 22, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 42, 43, 44, 45, 47, 48, 50, 51, 52, 54, 55, 57, 58, 60, 61, 63, 65, 66, 68, 70, 71, 73, 75, 77, 79, 81, 83, 84, 86, 88, 90, 93, 95, 97, 99, 101, 103, 106, 108, 110, 113, 115, 118, 120, 123, 125, 128, 130, 133, 136, 138, 141, 144, 147, 149, 152, 155, 158, 161, 164, 167, 171, 174, 177, 180, 183, 187, 190, 194, 197, 200, 204, 208, 211, 215, 218, 222, 226, 230, 234, 237, 241, 245, 249, 254, 258, 262, 266, 270, 275, 279, 283, 288, 292, 297, 301, 306, 311, 315, 320, 325, 330, 335, 340, 345, 350, 355, 360, 365, 370, 376, 381, 386, 392, 397, 403, 408, 414, 420, 425, 431, 437, 443, 449, 455, 461, 467, 473, 480, 486, 492, 499, 505, 512, 518, 525, 532, 538, 545, 552, 559, 566, 573, 580, 587, 594, 601, 609, 616, 624, 631, 639, 646, 654, 662, 669, 677, 685, 693, 701, 709, 717, 726, 734, 742, 751, 759, 768, 776, 785, 794, 802, 811, 820, 829, 838, 847, 857, 866, 875, 885, 894, 903, 913, 923, 932, 942, 952, 962, 972, 982, 992, 1002, 1013, 1023
};

const unsigned short gamma149half[256] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 7, 7, 7, 8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17, 18, 19, 20, 20, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33, 35, 36, 37, 38, 40, 41, 43, 44, 46, 47, 49, 50, 52, 54, 55, 57, 59, 61, 63, 64, 66, 68, 70, 72, 74, 77, 79, 81, 83, 85, 88, 90, 92, 95, 97, 100, 102, 105, 107, 110, 113, 115, 118, 121, 124, 127, 130, 133, 136, 139, 142, 145, 149, 152, 155, 158, 162, 165, 169, 172, 176, 180, 183, 187, 191, 195, 199, 203, 207, 211, 215, 219, 223, 227, 232, 236, 240, 245, 249, 254, 258, 263, 268, 273, 277, 282, 287, 292, 297, 302, 308, 313, 318, 323, 329, 334, 340, 345, 351, 357, 362, 368, 374, 380, 386, 392, 398, 404, 410, 417, 423, 429, 436, 442, 449, 455, 462, 469, 476, 483, 490, 497, 504, 511, 518, 525, 533, 540, 548, 555, 563, 571, 578, 586, 594, 602, 610, 618, 626, 634, 643, 651, 660, 668, 677, 685, 694, 703, 712, 721, 730, 739, 748, 757, 766, 776, 785, 795, 804, 814, 824, 833, 843, 853, 863, 873, 884, 894, 904, 915, 925, 936, 946, 957, 968, 979, 990, 1001, 1012, 1023
};


const unsigned short gamma98half[256] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17, 17, 18, 19, 20, 21, 22, 23, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33, 34, 36, 37, 38, 40, 41, 42, 44, 45, 47, 48, 50, 52, 53, 55, 57, 59, 60, 62, 64, 66, 68, 70, 72, 74, 77, 79, 81, 83, 86, 88, 91, 93, 96, 98, 101, 104, 106, 109, 112, 115, 118, 121, 124, 127, 130, 133, 136, 140, 143, 147, 150, 154, 157, 161, 165, 168, 172, 176, 180, 184, 188, 192, 197, 201, 205, 210, 214, 219, 223, 228, 233, 238, 243, 248, 253, 258, 263, 268, 274, 279, 284, 290, 296, 301, 307, 313, 319, 325, 331, 337, 344, 350, 356, 363, 369, 376, 383, 390, 397, 404, 411, 418, 425, 433, 440, 448, 456, 463, 471, 479, 487, 495, 503, 512, 520, 529, 537, 546, 555, 564, 573, 582, 591, 600, 610, 619, 629, 639, 648, 658, 668, 679, 689, 699, 710, 720, 731, 742, 753, 764, 775, 786, 798, 809, 821, 832, 844, 856, 868, 881, 893, 905, 918, 931, 943, 956, 969, 983, 996, 1009, 1023
};

const unsigned short gamma46half[256] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9, 9, 10, 10, 11, 11, 12, 13, 13, 14, 14, 15, 16, 17, 17, 18, 19, 20, 21, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 36, 37, 38, 40, 41, 43, 44, 46, 48, 49, 51, 53, 55, 57, 58, 60, 62, 65, 67, 69, 71, 73, 76, 78, 81, 83, 86, 88, 91, 94, 97, 100, 103, 106, 109, 112, 115, 119, 122, 126, 129, 133, 137, 140, 144, 148, 152, 156, 161, 165, 169, 174, 179, 183, 188, 193, 198, 203, 208, 213, 219, 224, 230, 236, 241, 247, 253, 260, 266, 272, 279, 285, 292, 299, 306, 313, 320, 328, 335, 343, 351, 359, 367, 375, 383, 392, 400, 409, 418, 427, 436, 446, 455, 465, 475, 485, 495, 505, 516, 526, 537, 548, 560, 571, 582, 594, 606, 618, 631, 643, 656, 669, 682, 695, 708, 722, 736, 750, 764, 779, 793, 808, 824, 839, 854, 870, 886, 903, 919, 936, 953, 970, 987, 1005, 1023
};

void delay()
{
	int delay_count=0;
	while(delay_count < 1)
	{
		delay_count++;
	}

}

void blank()
{
	int row;
	int col;

	  for(  row =0; row < 32; row++)
	  {
		  for( col=0; col < 32; col++)
		  {
			  int addr = 1024;
			  addr+= 32*row;
			  addr+=col;

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_ADDR_BASE, addr);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_DATA_BASE, 0x00);

			  delay();
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x01);
			  delay();
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);
		  }
	  }

}

void setPixel(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b)
{
	int addr = 1024 + 32*x + y;

	unsigned int rgb = ((r << 20) & 0x3FF00000) | ((g << 10) & 0x0FFC00) | (b & 0x0003FF);

	IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_ADDR_BASE, addr);
	IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_DATA_BASE, rgb);

	IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x01);
	IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

}

// Writes a bitmap to the FPGA memory frame buffer
// Expects 1024 pixels, 8 bits per red green blue colour channel
void displayBitmap(const unsigned int* bitmap)
{
	int i;


	  for(  i =0; i < 1024; i++)
	  {
			  int addr = 1024 + i;

			  unsigned int pixel = bitmap[i] ;

			  unsigned short b8 = gamma46half[(pixel >> 16) & 0xFF];
			  unsigned short g8 = gamma46half[(pixel >> 8) & 0xFF];
			  unsigned short r8 = gamma46half[(pixel) & 0xFF];

			  unsigned int rgb = ((r8 << 20) & 0x3FF00000) | ((g8 << 10) & 0x0FFC00) | (b8 & 0x0003FF);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_ADDR_BASE, addr);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_DATA_BASE, rgb);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x01);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

	  }
}




void displayColourBars()
{
	int row;
	int col;

	for(row = 0; row < 32; row++)
	{
		for(col=0;col<32;col++)
		{
			  int addr = 1024;
			  addr+= 32*row;
			  addr+=col;

			  unsigned short r8,g8,b8;

			  if(row < 4)
			  {
				  r8 = linearRGB[(int)(255.0 * (col/31.0))];
				  g8 = 0;
				  b8=0;
			  }
			  else if(row >= 4 && row < 8)
			  {
				  r8 = linearRGB[(int)(255.0 * (col/31.0))];
				  g8 = linearRGB[(int)(255.0 * (col/31.0))];
				  b8=0;
			  }
			  else if(row >= 8 && row < 12)
			  {
				  r8 = 0;
				  g8 = linearRGB[(int)(255.0 * (col/31.0))];
				  b8=0;
			  }
			  else if(row >= 12 && row < 16)
			  {
				  r8 = 0;
				  g8 = linearRGB[(int)(255.0 * (col/31.0))];
				  b8= linearRGB[(int)(255.0 * (col/31.0))];
			  }
			  else if( row >= 16 && row < 20)
			  {
				  r8 = 0;
				  g8=0;
				  b8 = linearRGB[(int)(255.0 * (col/31.0))];
			  }
			  else if( row >= 20 && row < 24)
			  {
				  r8 = linearRGB[(int)(255.0 * (col/31.0))];;
				  g8=0;
				  b8 = linearRGB[(int)(255.0 * (col/31.0))];
			  }
			  else
			  {
				  r8 = linearRGB[(int)(255.0 * (col/31.0))];
				  g8 = linearRGB[(int)(255.0 * (col/31.0))];
				  b8 = linearRGB[(int)(255.0 * (col/31.0))];
			  }


			  unsigned int rgb = ((r8 << 20) & 0x3FF00000) | ((g8 << 10) & 0x0FFC00) | (b8 & 0x0003FF);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_ADDR_BASE, addr);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_DATA_BASE, rgb);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x01);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

		}
	}
}

void displayCIEColourBars()
{
	int row;
	int col;

	for(row = 0; row < 32; row++)
	{
		for(col=0;col<32;col++)
		{
			  int addr = 1024;
			  addr+= 32*row;
			  addr+=col;

			  unsigned short r8,g8,b8;

			  if(row < 8)
			  {
				  r8 = cie1931[(int)(255.0 * (col/31.0))];
				  g8 = 0;
				  b8=0;
			  }
			  else if(row >= 8 && row < 16)
			  {
				  r8 = 0;
				  g8 = cie1931[(int)(255.0 * (col/31.0))];
				  b8=0;
			  }
			  else if( row >= 16 && row < 24)
			  {
				  r8 = 0;
				  g8=0;
				  b8 = cie1931[(int)(255.0 * (col/31.0))];

			  }
			  else
			  {
				  r8 = cie1931[(int)(255.0 * (col/31.0))];
				  g8= cie1931[(int)(255.0 * (col/31.0))];
				  b8 = cie1931[(int)(255.0 * (col/31.0))];
			  }



			  unsigned int rgb = ((r8 << 20) & 0x3FF00000) | ((g8 << 10) & 0x0FFC00) | (b8 & 0x0003FF);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_ADDR_BASE, addr);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_DATA_BASE, rgb);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x01);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

		}
	}
}


void displayGamma149ColourBars()
{
	int row;
	int col;

	for(row = 0; row < 32; row++)
	{
		for(col=0;col<32;col++)
		{
			  int addr = 1024;
			  addr+= 32*row;
			  addr+=col;

			  unsigned short r8,g8,b8;

			  if(row < 8)
			  {
				  r8 = gamma149half[(int)(255.0 * (col/31.0))];
				  g8 = 0;
				  b8=0;
			  }
			  else if(row >= 8 && row < 16)
			  {
				  r8 = 0;
				  g8 = gamma149half[(int)(255.0 * (col/31.0))];
				  b8=0;
			  }
			  else if( row >= 16 && row < 24)
			  {
				  r8 = 0;
				  g8=0;
				  b8 = gamma149half[(int)(255.0 * (col/31.0))];

			  }
			  else
			  {
				  r8 = gamma149half[(int)(255.0 * (col/31.0))];
				  g8= gamma149half[(int)(255.0 * (col/31.0))];
				  b8 = gamma149half[(int)(255.0 * (col/31.0))];
			  }




			  unsigned int rgb = ((r8 << 20) & 0x3FF00000) | ((g8 << 10) & 0x0FFC00) | (b8 & 0x0003FF);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_ADDR_BASE, addr);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_DATA_BASE, rgb);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x01);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

		}
	}
}


void displayGamma98ColourBars()
{
	int row;
	int col;

	for(row = 0; row < 32; row++)
	{
		for(col=0;col<32;col++)
		{
			  int addr = 1024;
			  addr+= 32*row;
			  addr+=col;

			  unsigned short r8,g8,b8;

			  if(row < 8)
			  {
				  r8 = gamma98half[(int)(255.0 * (col/31.0))];
				  g8 = 0;
				  b8=0;
			  }
			  else if(row >= 8 && row < 16)
			  {
				  r8 = 0;
				  g8 = gamma98half[(int)(255.0 * (col/31.0))];
				  b8=0;
			  }
			  else if( row >= 16 && row < 24)
			  {
				  r8 = 0;
				  g8=0;
				  b8 = gamma98half[(int)(255.0 * (col/31.0))];

			  }
			  else
			  {
				  r8 = gamma98half[(int)(255.0 * (col/31.0))];
				  g8= gamma98half[(int)(255.0 * (col/31.0))];
				  b8 = gamma98half[(int)(255.0 * (col/31.0))];
			  }




			  unsigned int rgb = ((r8 << 20) & 0x3FF00000) | ((g8 << 10) & 0x0FFC00) | (b8 & 0x0003FF);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_ADDR_BASE, addr);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_DATA_BASE, rgb);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x01);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

		}
	}
}

void displayGamma46ColourBars()
{
	int row;
	int col;

	for(row = 0; row < 32; row++)
	{
		for(col=0;col<32;col++)
		{
			  int addr = 1024;
			  addr+= 32*row;
			  addr+=col;

			  unsigned short r8,g8,b8;

			  if(row < 8)
			  {
				  r8 = gamma46half[(int)(255.0 * (col/31.0))];
				  g8 = 0;
				  b8=0;
			  }
			  else if(row >= 8 && row < 16)
			  {
				  r8 = 0;
				  g8 = gamma46half[(int)(255.0 * (col/31.0))];
				  b8=0;
			  }
			  else if( row >= 16 && row < 24)
			  {
				  r8 = 0;
				  g8=0;
				  b8 = gamma46half[(int)(255.0 * (col/31.0))];

			  }
			  else
			  {
				  r8 = gamma46half[(int)(255.0 * (col/31.0))];
				  g8= gamma46half[(int)(255.0 * (col/31.0))];
				  b8 = gamma46half[(int)(255.0 * (col/31.0))];
			  }




			  unsigned int rgb = ((r8 << 20) & 0x3FF00000) | ((g8 << 10) & 0x0FFC00) | (b8 & 0x0003FF);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_ADDR_BASE, addr);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_DATA_BASE, rgb);

			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x01);
			  IOWR_ALTERA_AVALON_PIO_DATA(DISPLAY_BUFFER_CTRL_BASE, 0x00);

		}
	}
}
