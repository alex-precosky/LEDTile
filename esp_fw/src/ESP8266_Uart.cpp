#include "Arduino.h"

void ESP8266_Uart_SendPacket(char* packet, int n)
{
  Serial.write(packet, n);
}
