#include <WiFi.h>
#include <HTTPClient.h>
#include "driver/i2s.h"
#include "secrets.h"


const char* ssid = WIFI_SSID; 
const char* password = WIFI_PASSWORD; 

const char* url = "http://<APP_SERVER_IP>:5000/audio.wav"; 

const int buttonPin = 4;


#define I2S_BCLK 7
#define I2S_LRC  15
#define I2S_DOUT 16

const int sampleRate = 24000;
float volume = 0.5;

void setupI2S() {
  i2s_config_t i2s_config = {
    .mode = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_TX),
    .sample_rate = sampleRate,
    .bits_per_sample = I2S_BITS_PER_SAMPLE_16BIT,
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
    .communication_format = I2S_COMM_FORMAT_I2S,
    .intr_alloc_flags = 0,
    .dma_buf_count = 8,
    .dma_buf_len = 128,
    .use_apll = false,
    .tx_desc_auto_clear = true,
    .fixed_mclk = 0
  };

  i2s_pin_config_t pin_config = {
    .bck_io_num = I2S_BCLK,
    .ws_io_num = I2S_LRC,
    .data_out_num = I2S_DOUT,
    .data_in_num = I2S_PIN_NO_CHANGE
  };

  i2s_driver_install(I2S_NUM_0, &i2s_config, 0, NULL);
  i2s_set_pin(I2S_NUM_0, &pin_config);
}

void setup() {
  Serial.begin(115200);
  pinMode(buttonPin, INPUT_PULLUP);

  setupI2S();

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

        uint8_t buffer[512];

        while (http.connected()) {

          int bytesRead = stream->readBytes(buffer, sizeof(buffer));

          if (bytesRead > 0) {


            for (int i = 0; i < bytesRead; i += 2) {
              int16_t sample = (buffer[i+1] << 8) | buffer[i];
              sample = sample * volume;
              buffer[i]   = sample & 0xFF;
              buffer[i+1] = (sample >> 8) & 0xFF;
            }

            size_t bytesWritten;
            i2s_write(I2S_NUM_0, buffer, bytesRead, &bytesWritten, portMAX_DELAY);
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