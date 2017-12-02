// Encodes and decodes packets for sending between the ESP8266 and the NIOS II

#ifndef __LEDPANEL_SERIAL_COMM_H__

    #define LEDPANEL_COMM_START_BYTE 0x00

    #define LEDPANEL_COMM_NOERROR 0x00
    #define LEDPANEL_COMM_CHECKSUM_ERROR 0x01
    #define LEDPANEL_COMM_START_BYTE_ERROR 0x01

    // Encoded packet will be stored in dest. It must be as big as the payload plus
    // 9 bytes for the start byte, four length bytes, and a four byte checksum
    void encode_serial_packet(char* dest, char* payload, int payload_size);


    /**
       @return error code, zero if no error
    */
    int decode_serial_packet(char* payload, char* packet);



#endif
