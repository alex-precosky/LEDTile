#include <Arduino.h>
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

    void onSetPixel();

void setup() {
  // Set up function pointer for sending packets
  Serial.begin(9600);
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

  Serial.begin(9600);
  server.begin();

}

void onSetPixel() {
  StaticJsonBuffer<200> jsonBuffer;

  String data = server.arg("plain");
  JsonObject& root = jsonBuffer.parseObject(data);
  
  int x = root["x"];
  int y = root["y"];
  int r = root["r"];
  int g = root["g"];
  int b = root["b"];

  if (x) 
  {
    server.send(200, "text/plain", "Sending Set pixel!");
    send_set_pixel(x, y, r, g, b);
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

