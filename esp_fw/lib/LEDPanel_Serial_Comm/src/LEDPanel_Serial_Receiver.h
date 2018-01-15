#ifndef __LEDPANEL_SERIAL_RECEIVER_H__
#define __LEDPANEL_SERIAL_RECEIVER_H__

#include "stdint.h"
#include "LEDPanel_Serial_Comm.h"

#ifdef __cplusplus
extern "C" {
#endif




  // state variable of the receiving of a serial packet
  typedef struct receive_status_s {
    short is_start_received;
    short is_length_received;
    short is_payload_received;
    uint32_t payload_length;
    uint32_t bytes_received;
    char buf[LEDPANEL_RECEIVE_BUFFER_SIZE];
  } receive_status_t;

  extern receive_status_t receive_status;

  // Initialize the state and the Uart
  void init_serial_receiver();

  // Call this for each character that is received by the Uart to update the state machine
  // and call the payload handler once a full payload has been received
  void process_serial_char(char ch);

  void process_serial_payload(char* payload, uint32_t payload_length);

  // Function pointers should be set up on the Nios II project to
  // point at functions that handle commands
  void (*Handle_SetPixel)(char x, char y, char r, char g, char b);


#ifdef __cplusplus
}
#endif
#endif
