// Encodes and decodes packets for sending between the ESP8266 and the NIOS II

#ifndef __LEDPANEL_SERIAL_COMM_H__
#define __LEDPANEL_SERIAL_COMM_H__


#ifdef __cplusplus
extern "C" {
#endif

    #include <stdint.h>

    #define LEDPANEL_RECEIVE_BUFFER_SIZE 3090

    #define LEDPANEL_COMM_START_BYTE 0x00

    #define LEDPANEL_COMM_NOERROR 0x00

    #define LEDPANEL_COMM_CHECKSUM_ERROR 0x01
    #define LEDPANEL_COMM_START_BYTE_ERROR 0x01

    #define LEDPANEL_COMM_CMD_SETPIXEL          0x01
    #define LEDPANEL_COMM_CMD_SETIMAGE          0x02
    #define LEDPANEL_COMM_CMD_SETANIMATIONFRAME 0x03
    #define LEDPANEL_COMM_CMD_STARTANIMATION    0x04

    #define LEDPANEL_COMM_HEADER_SIZE           0x05
    #define LEDPANEL_COMM_CHECKSUM_SIZE         0x04
    #define LEDPANEL_COMM_FRAME_EXTRAS_SIZE     (LEDPANEL_COMM_HEADER_SIZE + LEDPANEL_COMM_CHECKSUM_SIZE)

    // Encoded packet will be stored in dest. It must be as big as the payload plus
    // 9 bytes for the start byte, four length bytes, and a four byte checksum
    void encode_serial_packet(char* dest, const char* payload, int payload_size);

    /**
       @return error code, zero if no error
    */
    int decode_serial_packet(char* payload, const char* packet);

  /**
     Only the ESP8266 sends packets... so it will only point to something on that platform
  */
  extern void (*Uart_SendPacket)(char* packet, int n);

  // Send using Uart_SendPacket serial commands
  void send_set_pixel(char x, char y, char r, char g, char b);
  void send_set_image(unsigned char* rgb_array);
  void send_set_animation_frame(uint32_t i, unsigned char* rgb_array);
  void send_start_animation(uint32_t num_frames, uint16_t delay_ms);

#ifdef __cplusplus
}
#endif
#endif

