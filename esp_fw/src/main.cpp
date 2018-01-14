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

void (*Uart_SendPacket)(char* packet, int n) = &ESP8266_Uart_SendPacket;

void setup() {
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

  server.begin();

}

void onSetPixel() {
  StaticJsonBuffer<200> jsonBuffer;

  String data = server.arg("plain");
  JsonObject& root = jsonBuffer.parseObject(data);
  
  const char* x = root["x"];
  if (x) 
  {
    server.send(200, "text/plain", "Hi I am Alex's LED panel sending a 200 OK to your HTTP API call");
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

