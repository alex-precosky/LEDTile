#ifndef __ESP8266_UART_H__
#define __ESP8266_UART_H__

#ifdef __cplusplus
extern "C" {
#endif

void ESP8266_Uart_SendPacket(char* packet, int n);

#ifdef __cplusplus
}
#endif
#endif