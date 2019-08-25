#pragma once

#include <stdint.h>

/* The sequence task is responsible for drawing images from a sequence of images,
 * one at a time, at the requested frame rate
 */

void CreateSequenceTask();

/* Copies an image into the playback frame memory at location image_num */
void SequenceLoadImage(unsigned char *rgb_pixels, uint32_t frame_index);

/* Starts playback from frame zero of a sequence loaded in memory */
/* Requires that LoadImage() has been used to load that many frames into memory */
void SequenceStart(uint32_t num_frames, uint16_t interval_ms);

/* Stops playback of the sequence. Whatever image is currently displayed
 * will remain on the display
 */
void SequenceStop();
