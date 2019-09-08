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


const char* ssid = "TP-LINK_2CBD";
const char* password = "19444598";
const char* host = "LEDPanel";

const int BAUD_RATE = 921600;

const int HTTP_RESPONSE_SIZE = 50;

static unsigned char image_bytes[1024*3];

    ESP8266WebServer server(80);
    String webPage = "";

    StaticJsonBuffer<JSON_OBJECT_SIZE(1) + 4570> jsonBuffer;

    void onSetPixel();
    void onClear();
    void onSetImage();
    void onSetAnimationFrame();
    void onStartAnimation();

void setup() {
  // Set up function pointer for sending packets
  Serial.begin(BAUD_RATE);
  set_uart_sendpacket_callback(ESP8266_Uart_SendPacket);

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
  server.on("/setAnimationFrame", HTTP_POST, onSetAnimationFrame);
  server.on("/startAnimation", HTTP_POST, onStartAnimation);


  Serial.begin(BAUD_RATE);
  server.begin();

}

void onClear() {

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
 
  if (root.success()) {
    send_set_pixel(x, y, r, g, b);
    server.send(200, "text/plain", "Sending Set pixel!");
  } else {
    server.send(400, "text/plain", "Bad request");
  }
  
}

void onSetImage() {

  unsigned long startTime = millis();
  unsigned long endTime;
  unsigned long elapsedTime;

  jsonBuffer.clear();

  String data = server.arg("plain");
  JsonObject& root = jsonBuffer.parseObject(data);

  if(root.success()) {
    const char* image_base64 = root["image_base64"];

    decode_base64((unsigned char*)image_base64, image_bytes);

    // takes about 30 ms
    send_set_image(image_bytes);

    endTime = millis();
    elapsedTime = endTime - startTime;    

    server.send(200, "text/plain", "Setting the image. Request handling time: " + String(elapsedTime, 10));
  } else {
    server.send(400, "text/plain", "Bad request");
  }
}

void onSetAnimationFrame() {

  jsonBuffer.clear();

  String data = server.arg("plain");
  JsonObject& root = jsonBuffer.parseObject(data);
  char response[HTTP_RESPONSE_SIZE];

  if(root.success()) {
    const char* image_base64 = root["image_base64"];

    uint32_t i;
    i = root["frame_index"];

    decode_base64((unsigned char*)image_base64, image_bytes);

    send_set_animation_frame(i, image_bytes);

    server.send(200, "text/plain", "Setting animation frame " + String(i, 10) + "!");
  } else {
    server.send(400, "text/plain", "Bad request");
  }
}

void onStartAnimation() {
  
  StaticJsonBuffer<200> jsonBuffer;

  String data = server.arg("plain");
  JsonObject& root = jsonBuffer.parseObject(data);
  
  uint32_t num_frames;
  num_frames = root["num_frames"];

  uint16_t delay_ms;
  delay_ms = root["delay_ms"];

  if (root.success()) {
    send_start_animation(num_frames, delay_ms);
    server.send(200, "text/plain", "Starting animation of length " + String(num_frames, 10) + " with delay " + String(delay_ms, 10));
  } else {
    server.send(400, "text/plain", "Bad request");
  }
  
}


void loop() {
   ArduinoOTA.handle();
   server.handleClient();
   digitalWrite(LED_BUILTIN, LOW);
}

