#include <string>
#include <cstring>
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"
#include "LEDPanel_Serial_Receiver.h"
#include "LEDPanel_Serial_Comm.h"

void FakeHandle_SetPixel(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b);
void FakeUart_SendPacket(char*, int);

void FakeHandle_SetPixel(unsigned char x, unsigned char y, unsigned char r, unsigned char g, unsigned char b)
{
  mock().actualCall("FakeHandle_SetPixel");
}

void FakeHandle_StartAnimation(uint32_t num_frames, uint16_t delay_ms) {
  mock().actualCall("FakeHandle_StartAnimation");
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
    Handle_StartAnimation = FakeHandle_StartAnimation;

    set_uart_sendpacket_callback(FakeUart_SendPacket);

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
  const int payload_size = 6;
  const int packet_size = payload_size + 9;

  char x = 1;
  char y = 2;
  char r = 3;
  char g = 4;
  char b = 5;

  mock().expectOneCall("FakeHandle_SetPixel");

  char packet[payload_size] = "";
  packet[0] = LEDPANEL_COMM_START_BYTE;
  memcpy(packet+1, &payload_size, 4);
  packet[5] = LEDPANEL_COMM_CMD_SETPIXEL;
  packet[6] = x;
  packet[7] = y;
  packet[8] = r;
  packet[9] = g;
  packet[10] = b;

  process_serial_chars(packet, packet_size);

  mock().checkExpectations();
}

TEST(SerialReceiverGroup, Test_ReceiveHandlePixelTwice)
{
  const int payload_size = 6;
  const int packet_size = payload_size + 9;

  char x = 1;
  char y = 2;
  char r = 3;
  char g = 4;
  char b = 5;

  mock().expectNCalls(5, "FakeHandle_SetPixel");

  char packet[payload_size] = "";
  packet[0] = LEDPANEL_COMM_START_BYTE;
  memcpy(packet+1, &payload_size, 4);
  packet[5] = LEDPANEL_COMM_CMD_SETPIXEL;
  packet[6] = x;
  packet[7] = y;
  packet[8] = r;
  packet[9] = g;
  packet[10] = b;

  process_serial_chars(packet, packet_size);
  process_serial_chars(packet, packet_size);
  process_serial_chars(packet, packet_size);
  process_serial_chars(packet, packet_size);
  process_serial_chars(packet, packet_size);

  mock().checkExpectations();
}

TEST(SerialReceiverGroup, Test_ReceiveHandlePixelTwoPackets)
{
  const int payload_size = 6;
  const int packet_size = payload_size + 9;

  char x = 1;
  char y = 2;
  char r = 3;
  char g = 4;
  char b = 5;

  mock().expectOneCall("FakeHandle_SetPixel");

  char packet[payload_size] = "";
  packet[0] = LEDPANEL_COMM_START_BYTE;
  memcpy(packet+1, &payload_size, 4);
  packet[5] = LEDPANEL_COMM_CMD_SETPIXEL;
  packet[6] = x;
  packet[7] = y;
  packet[8] = r;
  packet[9] = g;
  packet[10] = b;

  process_serial_chars(packet, packet_size - 5);
  process_serial_chars(packet + packet_size - 5, 5);

  mock().checkExpectations();
}

TEST(SerialReceiverGroup, Test_ReceiveHandlePixelTwoCommands)
{
  const int payload_size = 6;
  const int packet_size = payload_size + 9;

  char x = 1;
  char y = 2;
  char r = 3;
  char g = 4;
  char b = 5;

  mock().expectNCalls(2, "FakeHandle_SetPixel");

  char packet[payload_size * 2] = "";
  packet[0] = LEDPANEL_COMM_START_BYTE;
  memcpy(packet+1, &payload_size, 4);
  packet[5] = LEDPANEL_COMM_CMD_SETPIXEL;
  packet[6] = x;
  packet[7] = y;
  packet[8] = r;
  packet[9] = g;
  packet[10] = b;
  memcpy(packet+packet_size, packet, packet_size);

  process_serial_chars(packet, packet_size * 2);

  mock().checkExpectations();
}

TEST(SerialReceiverGroup, Test_ReceiveHandleStartAnimation)
{
  mock().expectOneCall("FakeHandle_StartAnimation");

  const int payload_size = 1;
  const int packet_size = payload_size + 9;

  char packet[payload_size] = "";
  packet[0] = LEDPANEL_COMM_START_BYTE;
  memcpy(packet+1, &payload_size, 4);
  packet[5] = LEDPANEL_COMM_CMD_STARTANIMATION;


  for(int i = 0; i < packet_size; i++) {
      process_serial_char(packet[i]);
  }

  mock().checkExpectations();
}
