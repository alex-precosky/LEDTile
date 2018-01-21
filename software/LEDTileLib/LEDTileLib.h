/*
 * LEDTileLib.h
 *
 *  Created on: Apr 12, 2015
 *      Author: Alex
 */

#ifndef LEDTILELIB_H_
#define LEDTILELIB_H_

void delay();

void blank();
void displayColourBars();
void displayCIEColourBars();
void displayGamma149ColourBars();
void displayGamma98ColourBars();
void displayGamma46ColourBars();
void displayBitmap(const unsigned int* bitmap);
void setPixel(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b);




#endif /* LEDTILELIB_H_ */
