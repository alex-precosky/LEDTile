
#include <string.h>
#include <stdint.h>
#include "LEDPanel_Serial_Comm.h"


void send_set_pixel(char x, char y, char r, char g, char b)
{
  // encodes a packet with the command for setting a pixel
  // and sends it to the FPGA

  // the payload looks like...:  [0x01][x][y][r][g][b]
  const int payload_size = 6;
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

void send_set_image(unsigned char* rgb_array)
{
    // Sets the entire display at once. Takes a string of the R, G, B, values for all 1024 pixels.
    // [0x02][r0][g0][b0][r1][g1][b1]...[r1023][g1023][b1023]
    const int payload_size = 1 + 1024*3;
    const int packet_size = payload_size + 9;
    static char payload[1 + 1024*3 + 9];
    static char packet[1 + 1024*3];

    payload[0] = LEDPANEL_COMM_CMD_SETIMAGE;
    memcpy(payload+1, rgb_array, 1024*3);

    encode_serial_packet(packet, payload, payload_size);

    Uart_SendPacket(packet, packet_size);  
}


void encode_serial_packet(char* dest, char* payload, int payload_size)
{
    dest[0] = LEDPANEL_COMM_START_BYTE;

    memcpy(dest+1, &payload_size, 4);
    memcpy(dest+5, payload, payload_size);

    // make up a fake checksum for now
    dest[5+payload_size] = 0xfc;
    dest[6+payload_size] = 0xfd;
    dest[7+payload_size] = 0xfe;
    dest[8+payload_size] = 0xff;

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

