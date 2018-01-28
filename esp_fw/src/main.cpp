#include <Arduino.h>
#include "base64.hpp"
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>
#include "LEDPanel_Serial_Comm.h"
#include "ESP8266_Uart.h"


const char* ssid = "SHAW-E75060";
const char* password = "25116A147879";
const char* host = "LEDPanel";

    ESP8266WebServer server(80);
    String webPage = "";

      StaticJsonBuffer<JSON_OBJECT_SIZE(1) + 4570> jsonBuffer;

    void onSetPixel();
    void onClear();
    void onSetImage();

void (*Uart_SendPacket)(char* packet, int n) = &ESP8266_Uart_SendPacket;

void setup() {
  // Set up function pointer for sending packets
  Serial.begin(230400);
  Uart_SendPacket = ESP8266_Uart_SendPacket;   

  WiFi.mode(WIFI_STA);

  WiFi.begin(ssid, password);

  while (WiFi.waitForConnectResult() != WL_CONNECTED){
    WiFi.begin(ssid, password);
  }

  ArduinoOTA.setHostname(host);

  ArduinoOTA.onError([](ota_error_t error) { ESP.restart(); });

  ArduinoOTA.begin();


  pinMode(LED_BUILTIN, OUTPUT);

  webPage += "<h1>LED Web Server</h1><p>Coming soon: A REST API for making this thing go!</p>";

  server.on("/", [](){
    server.send(200, "text/html", webPage);
  });

  server.on("/setPixel", HTTP_POST, onSetPixel);
  server.on("/clear", HTTP_POST, onClear);
  server.on("/setImage", HTTP_POST, onSetImage);

  Serial.begin(230400);
  server.begin();

}

void onClear() {

  unsigned char image_bytes[1024*3];

  memset(image_bytes, 0, 1024*3);

  send_set_image(image_bytes);

  server.send(200, "text/plain", "Clearing!");
}

void onSetPixel() {
  
  StaticJsonBuffer<200> jsonBuffer;

  String data = server.arg("plain");
  JsonObject& root = jsonBuffer.parseObject(data);
  
  int x,y,r,g,b;
  x = root["x"];
  y = root["y"];
  r = root["r"];
  g = root["g"];
  b = root["b"];
 
  if (root.success()) 
  {
    send_set_pixel(x, y, r, g, b);
    server.send(200, "text/plain", "Sending Set pixel!");
  }
  else
  {
    server.send(400, "text/plain", "Bad request");
  }
  
}

void onSetImage()
{

jsonBuffer.clear();

  String data = server.arg("plain");
  JsonObject& root = jsonBuffer.parseObject(data);
  unsigned char image_bytes[1024*3];

  if(root.success())
  {
    const char* image_base64 = root["image_base64"];

    decode_base64((unsigned char*)image_base64, image_bytes);

    send_set_image(image_bytes);

    server.send(200, "text/plain", "Setting the image!");
  }
  else
  {
    server.send(400, "text/plain", "Bad request");
  }
}

void loop() {
   ArduinoOTA.handle();
    server.handleClient();
   digitalWrite(LED_BUILTIN, LOW);
}

