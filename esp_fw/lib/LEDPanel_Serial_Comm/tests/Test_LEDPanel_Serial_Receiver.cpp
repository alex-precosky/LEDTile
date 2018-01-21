#include <string>
#include <cstring>
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"
#include "LEDPanel_Serial_Receiver.h"
#include "LEDPanel_Serial_Comm.h"

void FakeHandle_SetPixel(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b);
void FakeUart_SendPacket(char*, int);

void (*Uart_SendPacket)(char* packet, int n) = &FakeUart_SendPacket;

void FakeHandle_SetPixel(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b)
{
  mock().actualCall("FakeHandle_SetPixel");
}

void FakeUart_SendPacket(char*, int)
{
  ;
}


TEST_GROUP(SerialReceiverGroup)
{
  void setup()
  {
    Handle_SetPixel = FakeHandle_SetPixel;
    Uart_SendPacket = FakeUart_SendPacket;

    init_serial_receiver();

  }

  void teardown()
  {
    mock().clear();
  }
 
};

TEST(SerialReceiverGroup, Test_StartByte)
{
    mock().expectNoCall("FakeHandle_SetPixel");
    process_serial_char(LEDPANEL_COMM_START_BYTE);
    mock().checkExpectations();   
}

TEST(SerialReceiverGroup, Test_SizeBytes)
{
    mock().expectNoCall("FakeHandle_SetPixel");
    process_serial_char(LEDPANEL_COMM_START_BYTE);

    process_serial_char(0x00);
    process_serial_char(0x00);
    process_serial_char(0x00);
    process_serial_char(0x00);

    mock().checkExpectations();   
}


TEST(SerialReceiverGroup, Test_CommandByte)
{
    mock().expectNoCall("FakeHandle_SetPixel");
    process_serial_char(LEDPANEL_COMM_START_BYTE);

    process_serial_char(0x01);
    process_serial_char(0x00);
    process_serial_char(0x00);
    process_serial_char(0x00);

    process_serial_char(LEDPANEL_COMM_CMD_SETPIXEL);  

    mock().checkExpectations();   
}

TEST(SerialReceiverGroup, Test_ArgumentBytes)
{
    mock().expectNoCall("FakeHandle_SetPixel");
    process_serial_char(LEDPANEL_COMM_START_BYTE);

    process_serial_char(0x06);
    process_serial_char(0x00);
    process_serial_char(0x00);
    process_serial_char(0x00);

    process_serial_char(LEDPANEL_COMM_CMD_SETPIXEL);  
    process_serial_char(0x00);
    process_serial_char(0x00);
    process_serial_char(0x00);
    process_serial_char(0x00);
    process_serial_char(0x00);
   
    mock().checkExpectations();   
}


TEST(SerialReceiverGroup, Test_ReceiveHandlePixel)
{
  mock().expectOneCall("FakeHandle_SetPixel");

  const int payload_size = 6;
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

  for(int i = 0; i < packet_size; i++)
    {
      process_serial_char(packet[i]);
    }

    mock().checkExpectations();
}
