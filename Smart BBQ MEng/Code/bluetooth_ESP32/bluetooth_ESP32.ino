/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleWrite.cpp
    Ported to Arduino ESP32 by Evandro Copercini
*/
#include <WiFi.h>

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

String bluetoothData="";
String wifiName="";
String wifiPassword="";
String experimentNumber="";
String data[3];

byte LED_BUILTIN2= 12;
byte WifiLedIndicator= 14;

class MyCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string value = pCharacteristic->getValue();

      
      int i=0;
      int arrayIndex=0;
      int start=0;
      while(i<value.length())
      {
        data[arrayIndex]="";
        if(value[i]==',')
        {
          for(int j=start;j<i;j++)
          {
            data[arrayIndex]=data[arrayIndex]+value[j];
          }
          start=i+1;
          arrayIndex=arrayIndex+1;
        }
        i++;
        
      }

      delay(4000);

      WiFi.mode(WIFI_AP); // workaround
      WiFi.mode(WIFI_AP_STA);

      const char* names=data[0].c_str();
      const char* pass=data[1].c_str();
      const char* ssid = "Vigram's iPhone";
      const char* password =  "abcdefgh";
      WiFi.begin(ssid, password); 

      Serial.println(names);
      
      Serial.println(pass);
      
      while (WiFi.status() != WL_CONNECTED) { //Check for the connection
      delay(1000);
      // WiFi.begin(ssid, password); 
      Serial.println("Connecting to WiFi..");
      }
      
      digitalWrite(WifiLedIndicator, HIGH);
      Serial.println("Connected to the WiFi network");

    }
};

void setup() {
  Serial.begin(115200);

  Serial.println("1- Download and install an BLE scanner app in your phone");
  Serial.println("2- Scan for BLE devices in the app");
  Serial.println("3- Connect to MyESP32");
  Serial.println("4- Go to CUSTOM CHARACTERISTIC in CUSTOM SERVICE and write something");
  Serial.println("5- See the magic =)");

  Serial.begin(115200);
  pinMode(LED_BUILTIN2, OUTPUT);
  pinMode(WifiLedIndicator, OUTPUT);

  digitalWrite(LED_BUILTIN2, HIGH);

  BLEDevice::init("MyESP32");
  BLEServer *pServer = BLEDevice::createServer();

  BLEService *pService = pServer->createService(SERVICE_UUID);

  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );


  pCharacteristic->setCallbacks(new MyCallbacks());

  pService->start();
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();
 
}

void loop() {
  Serial.print(bluetoothData);
  
  // put your main code here, to run repeatedly:
  delay(2000);
}
