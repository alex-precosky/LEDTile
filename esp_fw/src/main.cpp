#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include <ESP8266WebServer.h>

const char* ssid = "SHAW-E75060";
const char* password = "25116A147879";
const char* host = "LEDPanel";

    ESP8266WebServer server(80);
    String webPage = "";


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

  server.begin();

}

void loop() {
   ArduinoOTA.handle();
    server.handleClient();
   digitalWrite(LED_BUILTIN, LOW);
}