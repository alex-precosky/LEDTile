#include <string.h>
#include <stdint.h>
#include "LEDPanel_Serial_Comm.h"


void send_set_pixel(char x, char y, char r, char g, char b)
{
  // encodes a packet with the command for setting a pixel
  // and sends it to the FPGA

  // the payload looks like...:  [0x01][x][y][r][g][b]
  const int payload_size = 7;
  const int packet_size = payload_size + 9;
  char payload[payload_size];
  char packet[packet_size];

  payload[0] = LEDPANEL_COMM_CMD_SETPIXEL;
  payload[1] = x;
  payload[2] = y;
  payload[3] = r;
  payload[4] = g;
  payload[5] = b;

  encode_serial_packet(packet, payload, payload_size);

  Uart_SendPacket(packet, packet_size);  
}

void encode_serial_packet(char* dest, char* payload, int payload_size)
{
    dest[0] = LEDPANEL_COMM_START_BYTE;
    memcpy(dest+1, &payload_size, 4);
    memcpy(dest+5, payload, payload_size);

    return;
}

int decode_serial_packet(char* payload, char* packet)
{
    if( packet[0] != LEDPANEL_COMM_START_BYTE )
        return LEDPANEL_COMM_CHECKSUM_ERROR;

    uint32_t length = *((uint32_t*)(packet+1));
    memcpy(payload, packet+5, length);

    return LEDPANEL_COMM_NOERROR;
}

