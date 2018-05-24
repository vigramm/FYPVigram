#include "esp_wpa2.h"
#include <WiFi.h>

const char *ssid = "eduroam";
#define EAP_ID "vm1114@ic.ac.uk"
#define EAP_USERNAME "vm1114"
#define EAP_PASSWORD "Loseyourself8196."

void setup() {

    Serial.begin(115200);
    delay(10);

    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);

    WiFi.disconnect(true);
    
    esp_wifi_sta_wpa2_ent_set_identity((uint8_t *)EAP_ID, strlen(EAP_ID));
    //esp_wifi_sta_wpa2_ent_set_username((uint8_t *)EAP_USERNAME, strlen(EAP_USERNAME));
    esp_wifi_sta_wpa2_ent_set_password((uint8_t *)EAP_PASSWORD, strlen(EAP_PASSWORD));

    esp_wpa2_config_t config = WPA2_CONFIG_INIT_DEFAULT(); 
    esp_err_t code = esp_wifi_sta_wpa2_ent_enable(&config);

    Serial.print("Code: ");
    Serial.println(code);
    
    WiFi.begin(ssid);

    while (WiFi.status() != WL_CONNECTED) {
        delay(2000);
        Serial.print(".");        
    }

    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
}

void loop() {

    

}
