#include <string>
#include <cstring>
#include "CppUTest/TestHarness.h"
#include "LEDPanel_Serial_Receiver.h"
#include "LEDPanel_Serial_Comm.h"

char Handle_SetPixel_Successful = 0;
void FakeHandle_SetPixel(char x, char y, char r, char g, char b);
void FakeUart_SendPacket(char*, int);

void (*Uart_SendPacket)(char* packet, int n) = &FakeUart_SendPacket;

void FakeHandle_SetPixel(char x, char y, char r, char g, char b)
{
  Handle_SetPixel_Successful = 1;
}

void FakeUart_SendPacket(char*, int)
{
  ;
}


TEST_GROUP(SerialReceiverGroup)
{
  void setup()
  {
    Handle_SetPixel_Successful = 0;
    Handle_SetPixel = FakeHandle_SetPixel;
    Uart_SendPacket = FakeUart_SendPacket;

  }
 
};

TEST(SerialReceiverGroup, Test_ReceiveHandlePixel)
{
  const int payload_size = 7;
  const int packet_size = payload_size + 9;

  char x = 1;
  char y = 2;
  char r = 3;
  char g = 4;
  char b = 5;

  char packet[payload_size] = "";
  packet[0] = LEDPANEL_COMM_START_BYTE;
  memcpy(packet+1, &payload_size, 4);
  packet[5] = LEDPANEL_COMM_CMD_SETPIXEL;
  packet[6] = x;
  packet[7] = y;
  packet[8] = r;
  packet[9] = g;
  packet[10] = b;

  init_serial_receiver();

  for(int i = 0; i < packet_size; i++)
    {
      process_serial_char(packet[i]);
    }

  CHECK(Handle_SetPixel_Successful);
}
