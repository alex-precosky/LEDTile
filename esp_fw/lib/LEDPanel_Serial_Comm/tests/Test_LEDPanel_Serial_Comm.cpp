#include <string>
#include "CppUTest/TestHarness.h"
#include "LEDPanel_Serial_Comm.h"


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

 TEST(SerialCommGroup, Test_decode)
 {
   char packet[20];
   char payload[10] = "xxxxxxxxx";
   char expected_payload[] = "My Packet";
   int payload_length = 9;

   // assumed intel, so little endian
   packet[0] = LEDPANEL_COMM_START_BYTE;
   packet[4] = (payload_length >> 24) & 0xFF;
   packet[3] = (payload_length >> 16) & 0xFF;
   packet[2] = (payload_length >> 8) & 0xFF;
   packet[1] = payload_length & 0xFF;   

   for(int i = 0; i < payload_length; i++)
     packet[i+5] = expected_payload[i];


   int error = decode_serial_packet(payload, packet);

   CHECK_EQUAL(LEDPANEL_COMM_NOERROR, error);

   STRNCMP_EQUAL("My Packet", payload, payload_length);
 }
