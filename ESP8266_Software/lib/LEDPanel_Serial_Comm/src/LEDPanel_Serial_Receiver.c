#include <stdint.h>

#include "LEDPanel_Serial_Receiver.h"
#include "LEDPanel_Serial_Comm.h"

receive_status_t receive_status;

void init_serial_receiver()
{
  receive_status.is_start_received = 0;
  receive_status.is_length_received = 0;
  receive_status.is_payload_received = 0;
  receive_status.payload_length = 0;
  receive_status.bytes_received = 0;
}

void process_serial_char(char ch)
{

  // do nothing if waiting for start byte and ch is not the start byte
  if( receive_status.is_start_received == 0 && ch != LEDPANEL_COMM_START_BYTE )
    return;

  // handle start byte
  if( receive_status.is_start_received == 0 && ch == LEDPANEL_COMM_START_BYTE )
    {
      receive_status.is_start_received = 1;
      receive_status.buf[ receive_status.bytes_received++ ] = ch;
      return;
    }

  // handle length byte reading
  if( receive_status.is_length_received == 0 )
    {
      receive_status.buf[ receive_status.bytes_received++ ] = ch;

      if( receive_status.bytes_received == 5 )
	    {
	      receive_status.payload_length = receive_status.buf[1] + (receive_status.buf[2] << 8) + (receive_status.buf[3] << 16) + (receive_status.buf[4] << 24);
	      receive_status.is_length_received =  1;
        if(receive_status.payload_length > LEDPANEL_RECEIVE_BUFFER_SIZE-9)  // if the length is too long, reset the receiver state
          init_serial_receiver();
	    }
      return;
    }

  // handle payload reading
  if( receive_status.is_payload_received == 0)
    {
      receive_status.buf[ receive_status.bytes_received++ ] = ch;
      if( receive_status.bytes_received == receive_status.payload_length  + 5)
	    {
	      receive_status.is_payload_received = 1;
	    }
      return;
    }

  // by here, all that's left is the checksum of 4 bytes
  receive_status.buf[ receive_status.bytes_received++ ] = ch;

  if( receive_status.bytes_received != (receive_status.payload_length + 5 + 4) )
    return;

  // todo: check the checksum

  // call the payload handler
  process_serial_payload( receive_status.buf+5, receive_status.payload_length );
  init_serial_receiver();

  return;
}


void process_serial_payload( char* payload, uint32_t payload_length )
{
  char command = payload[0];

  switch( command )
    {
      case LEDPANEL_COMM_CMD_SETPIXEL:
        ;
      	char x = payload[1];
        char y = payload[2];
        char r = payload[3];
        char g = payload[4];
        char b = payload[5];

      	Handle_SetPixel(x, y, r, g, b);
	      break;

      case LEDPANEL_COMM_CMD_SETIMAGE:
        ;
        Handle_SetImage((unsigned char*)payload+1); // skip the first byte, which is the command byte. The rest is pixels
        break;

      case LEDPANEL_COMM_CMD_SETANIMATIONFRAME:
        ;

        uint32_t frame_index;
        memcpy(&frame_index, payload+4, 4);

        Handle_SetAnimationFrame(frame_index, (unsigned char*)payload+8);
        break;

      case LEDPANEL_COMM_CMD_STARTANIMATION:
        ;

        uint32_t num_frames;
        memcpy(&num_frames, payload+4, 4);

        uint16_t delay_ms;
        memcpy(&delay_ms, payload+8, 2);

        Handle_StartAnimation(num_frames, delay_ms);
        break;
    }
}