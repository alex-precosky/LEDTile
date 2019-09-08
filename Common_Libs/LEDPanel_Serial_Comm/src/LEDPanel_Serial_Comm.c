
#include <string.h>
#include <stdint.h>
#include "LEDPanel_Serial_Comm.h"

void (*Uart_SendPacket)(char* packet, int n) = 0xDEADBEEF;

 void set_uart_sendpacket_callback(void (*Uart_SendPacketParam)(char* packet, int n))
 {
     Uart_SendPacket = Uart_SendPacketParam;
 }

void send_set_pixel(char x, char y, char r, char g, char b)
{
  // encodes a packet with the command for setting a pixel
  // and sends it to the FPGA

  // the payload looks like...:  [0x01][x][y][r][g][b]
#define set_pixel_payload_size (6)
#define set_pixel_packet_size (set_pixel_payload_size + 9)

  char payload[set_pixel_payload_size];
  char packet[set_pixel_packet_size];

  payload[0] = LEDPANEL_COMM_CMD_SETPIXEL;
  payload[1] = x;
  payload[2] = y;
  payload[3] = r;
  payload[4] = g;
  payload[5] = b;

  encode_serial_packet(packet, payload, set_pixel_payload_size);

  Uart_SendPacket(packet, set_pixel_packet_size);
}

void send_set_image(unsigned char* rgb_array)
{
    // Sets the entire display at once. Takes a string of the R, G, B, values for all 1024 pixels.
    // [0x02][r0][g0][b0][r1][g1][b1]...[r1023][g1023][b1023]
    const int payload_size = 1 + 1024*3;
    const int packet_size = payload_size + 9;
    static char payload[1 + 1024*3];
    static char packet[1 + 1024*3 + 9];

    payload[0] = LEDPANEL_COMM_CMD_SETIMAGE;
    memcpy(payload+1, rgb_array, 1024*3);

    encode_serial_packet(packet, payload, payload_size);

    Uart_SendPacket(packet, packet_size);  
}

void send_set_animation_frame(uint32_t frame_index, unsigned char* rgb_array) {
    // Sets the entire display at once. Takes a string of the R, G, B, values for all 1024 pixels.
    // [0x03][0x00][0x00][0x00][frame_index0][frame_index1][frame_index2][frame_index3][r0][g0][b0][r1][g1][b1]...[r1023][g1023][b1023]
	// Second byte is padding for 2-byte alignment requirement on NIOS ii (TODO dont need this anymore)
    const int payload_size = 4 + 4 + 1024*3;
    const int packet_size = payload_size + 9;
    static char payload[4 + 4 + 1024*3];
    static char packet[4 + 4 + 1024*3 + 9];

    payload[0] = LEDPANEL_COMM_CMD_SETANIMATIONFRAME;
    payload[1] = 0x00;
    payload[2] = 0x00;
    payload[3] = 0x00;

    memcpy(payload+4, &frame_index, sizeof(frame_index));
    memcpy(payload+8, rgb_array, 1024*3);

    encode_serial_packet(packet, payload, payload_size);

    Uart_SendPacket(packet, packet_size);  
}

void send_start_animation(uint32_t num_frames, uint16_t delay) {
  // [0x04][0x00][0x00][0x00][num_frames0][num_frames1][num_frames2][num_frames3][delay_ms0][delay_ms1]
  // Second byte is padding for 2-byte alignment requirement on NIOS ii (TODO dont need this anymore)
  const int payload_size = 4 + 4 + 2;
  const int packet_size = payload_size + 9;
  static char payload[4 + 4 + 2];
  static char packet[4 + 4 + 2 + 9];

  payload[0] = LEDPANEL_COMM_CMD_STARTANIMATION;
  payload[1] = 0x00;
  payload[2] = 0x00;
  payload[3] = 0x00;
  memcpy(payload+4, &num_frames, sizeof(num_frames));
  memcpy(payload+8, &delay, sizeof(delay));
  encode_serial_packet(packet, payload, payload_size);

  Uart_SendPacket(packet, packet_size);
}


void encode_serial_packet(char* dest, const char* payload, int payload_size)
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

int decode_serial_packet(char* payload, const char* packet)
{
    if( packet[0] != LEDPANEL_COMM_START_BYTE )
        return LEDPANEL_COMM_CHECKSUM_ERROR;


    uint32_t length = *((uint32_t*)(packet+1));
    memcpy(payload, packet+5, length);

    return LEDPANEL_COMM_NOERROR;

}

