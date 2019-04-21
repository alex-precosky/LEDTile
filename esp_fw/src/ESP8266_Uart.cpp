#include "Arduino.h"

void ESP8266_Uart_SendPacket(char* packet, int n)
{
  Serial.write((uint8_t*)packet, (size_t)n);
}
