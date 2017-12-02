#include "CppUTest/TestHarness.h"
#include "LEDPanel_Serial_Comm.h"
//extern "C" void encode_serial_packet(char* dest, char* payload, int payload_size);

TEST_GROUP(SerialCommGroup)
{
};

TEST(SerialCommGroup, Test_encode)
{
  char payload[] = "My Packet";
  char packet[20] = "xxxxxxxxxxxxxxxxxxx";
  int payload_size = 9;
  encode_serial_packet(packet, payload, payload_size);

  CHECK_EQUAL(LEDPANEL_COMM_START_BYTE, packet[0]);
  CHECK_EQUAL(payload_size,  *((int*)(packet+1) ) );
  STRNCMP_EQUAL("My Packet", packet+5, payload_size);

}
