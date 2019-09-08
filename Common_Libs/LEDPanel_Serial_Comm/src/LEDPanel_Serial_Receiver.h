#ifndef __LEDPANEL_SERIAL_RECEIVER_H__
#define __LEDPANEL_SERIAL_RECEIVER_H__

#include "stdint.h"
#include "LEDPanel_Serial_Comm.h"

#ifdef __cplusplus
extern "C" {
#endif


#if defined(_MSC_VER)
#define ALIGNED_(x) __declspec(align(x))
#else
#if defined(__GNUC__)
#define ALIGNED_(x) __attribute__ ((aligned(x)))
#endif
#endif

#define ALIGNED_TYPE_(t,x) typedef t ALIGNED_(x)

  // state variable of the receiving of a serial packet
  ALIGNED_TYPE_(struct, 4) receive_status_s {
    short is_start_received;
    short is_length_received;
    short is_payload_received;
    uint32_t payload_length;
    uint32_t bytes_received;
    char buf[LEDPANEL_RECEIVE_BUFFER_SIZE];
  }receive_status_t;

  extern receive_status_t receive_status;

  // Initialize the state and the Uart
  void init_serial_receiver();

  // Call this for each character that is received by the Uart to update the state machine
  // and call the payload handler once a full payload has been received
  void process_serial_char(char ch);

  void process_serial_payload(char* payload, uint32_t payload_length);

  // Function pointers should be set up on the Nios II project to
  // point at functions that handle commands
  void (*Handle_SetPixel)(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b);
  void (*Handle_SetImage)(unsigned char* rgb_pixels);
  void (*Handle_SetAnimationFrame)(uint32_t frame_index, unsigned char* rgb_pixels);
  void (*Handle_StartAnimation)(uint32_t num_frames, uint16_t delay_ms);


#ifdef __cplusplus
}
#endif
#endif
