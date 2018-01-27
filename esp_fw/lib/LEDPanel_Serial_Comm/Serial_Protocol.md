# LED Panel Serial Protocol
Describes communications between the ESP8266 WiFi module and the Nios II core soft CPU.  Communications are from the ESP to the Nios II, commanding it to do things.  

## Serial Frame

Each command is sent in a frame:

[Start Byte][Payload Length][Payload][CRC32]
 - Start Byte: 0x00
 - Length: 4 byte integer, is of just the payload
 - Payload: some command
 - CRC32: 4 bytes

## Payload

These are commands that take the form

[Command Byte][One or more arguments]

### Set Pixel
All arguments as single bytes

[0x01][x][y][r][g][b]

### Set Display
Sets the entire display at once. Takes a string of the R, G, B, values for all 1024 pixels.

[0x02][r0][g0][b0][r1][g1][b1]...[r1023][g1023][b1023]

