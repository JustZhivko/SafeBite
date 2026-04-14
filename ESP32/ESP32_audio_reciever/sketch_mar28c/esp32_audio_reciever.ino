#include <WiFi.h>
#include <HTTPClient.h>
#include "secrets.h"

const char* ssid = WIFI_SSID; 
const char* password = WIFI_PASSWORD; 

const char* url = "http://<APP_SERVER_IP>:5000/audio.wav"; 


const int pwmPin = 5;
const int pwmFreq = 50000;
const int resolution = 8;


const int sampleRate = 16000;


float volume = 0.2;

WiFiClient client;


const int buttonPin = 4;

void setup() {
  Serial.begin(115200);


  ledcAttach(pwmPin, pwmFreq, resolution);


  pinMode(buttonPin, INPUT_PULLUP);


  WiFi.begin(ssid, password);
  Serial.print("Connecting");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConnected!");
}

void loop() {

  if (digitalRead(buttonPin) == LOW) {
    if (WiFi.status() == WL_CONNECTED) {

      HTTPClient http;
      http.begin(url);

      int httpCode = http.GET();

      if (httpCode == HTTP_CODE_OK) {
        WiFiClient *stream = http.getStreamPtr();


        for (int i = 0; i < 44; i++) {
          stream->read();
        }

        unsigned long lastSampleTime = micros();

        while (http.connected() && stream->available()) {

          if (micros() - lastSampleTime >= (1000000 / sampleRate)) {
            lastSampleTime = micros();

            int sample = stream->read();

            if (sample >= 0) {

              int centered = sample - 128;
              int scaled = (centered * volume) + 128;

              if (scaled < 0) scaled = 0;
              if (scaled > 255) scaled = 255;

              ledcWrite(pwmPin, scaled);

            } else {
              ledcWrite(pwmPin, 128);
            }
          }
        }

        Serial.println("Playback done");
      } else {
        Serial.println("HTTP error");
      }

      http.end();
    }
    
    while (digitalRead(buttonPin) == LOW) {
      delay(10);
    }
  }

  delay(100);
}