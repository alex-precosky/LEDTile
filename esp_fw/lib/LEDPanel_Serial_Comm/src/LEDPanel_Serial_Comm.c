#include <string.h>
#include <stdint.h>
#include "LEDPanel_Serial_Comm.h"

void encode_serial_packet(char* dest, char* payload, int payload_size)
{
    dest[0] = LEDPANEL_COMM_START_BYTE;
    memcpy(dest+1, payload, payload_size);

    return;
}

int decode_serial_packet(char* payload, char* packet)
{
    if( packet[0] != LEDPANEL_COMM_START_BYTE )
        return LEDPANEL_COMM_CHECKSUM_ERROR;

    uint32_t length = *(payload+1);

    memcpy(payload, packet+1, length);

    return LEDPANEL_COMM_NOERROR;
}

