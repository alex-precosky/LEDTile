#include <stdbool.h>
#include <string.h>
#include "app_cfg.h"
#include "includes.h"
#include "LEDTileLib.h"
#include "sequenceTask.h"

#define MAX_NUM_FRAMES 1000
#define IMAGE_SIZE 1024*3
static unsigned char image_frames[MAX_NUM_FRAMES*IMAGE_SIZE];

static uint32_t s_cur_frame_index = 0;
static uint16_t s_frame_period_ms = 0;
static uint32_t s_num_frames = 0;
static bool s_is_playing = false;

static const uint16_t S_IDLE_DELAY_MS = 250;


static OS_STK displayTaskStk[TASK_STACKSIZE];
static void SequenceTask(void* pdata);

void CreateSequenceTask()
{
	OSTaskCreateExt(SequenceTask,
			NULL,
			(void *)&displayTaskStk[TASK_STACKSIZE-1],
			TASK_PRIORITY_DISPLAY,
			TASK_PRIORITY_DISPLAY,
			displayTaskStk,
			TASK_STACKSIZE,
			NULL,
			0);
}

static void SequenceTask(void* pdata)
{
	while (true) {
		if (true == s_is_playing) {
			HandleSetImageCommand(image_frames + (s_cur_frame_index*IMAGE_SIZE));
			s_cur_frame_index = (s_cur_frame_index + 1) % s_num_frames;
			OSTimeDlyHMSM(0, 0, 0, s_frame_period_ms);
		} else {
			OSTimeDlyHMSM(0, 0, 0, S_IDLE_DELAY_MS);
		}
	}
}

void SequenceLoadImage(unsigned char *rgb_pixels, uint32_t frame_index)
{
	if (frame_index > MAX_NUM_FRAMES)
		return; // TODO should be able to return an error

	memcpy(image_frames + (frame_index * IMAGE_SIZE), rgb_pixels, IMAGE_SIZE);
}

void SequenceStart(uint32_t num_frames, uint16_t interval_ms)
{
	s_cur_frame_index = 0;
	s_frame_period_ms = interval_ms;
	s_num_frames = num_frames;
	s_is_playing = true;
}

void SequenceStop()
{
	s_is_playing = false;
}
