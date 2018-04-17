#include <Firebase.h>
#include <FirebaseArduino.h>
#include <FirebaseCloudMessaging.h>
#include <FirebaseError.h>
#include <FirebaseHttpClient.h>
#include <FirebaseObject.h>


#include <ESP8266WiFi.h>
#include <ESP8266WiFiAP.h>
#include <ESP8266WiFiGeneric.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266WiFiScan.h>
#include <ESP8266WiFiSTA.h>
#include <ESP8266WiFiType.h>
#include <WiFiClient.h>
#include <WiFiClientSecure.h>
#include <WiFiServer.h>
#include <WiFiUdp.h>


//#include
//#include

// Set these to run example.

#define FIREBASE_HOST "smartbbq-9bfc3.firebaseio.com"

#define FIREBASE_AUTH "XL5osW1DYgFpRBEcmEBTERisMDvZCEVCwfnfBd6s"

#define WIFI_SSID "Vigram's iPhone"

#define WIFI_PASSWORD "abcdefgh"

#define LED 2

int counter = 1;
int interval = 1;

void setup() {

  pinMode(LED, OUTPUT);

  digitalWrite(LED, 0);

  Serial.begin(9600);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("connecting");

  while (WiFi.status() != WL_CONNECTED) {

    Serial.print(".");

    delay(500);

  }

  Serial.println();

  Serial.print("connected: ");

  Serial.println(WiFi.localIP());

  

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
 
 // Firebase.setInt("smartbbq-9bfc3/"+ExperimentNumber+"/0", 56);


}





void loop() {

  String ExperimentNumber="Experiment1";
  String counterString = String(counter);

  Firebase.setInt(ExperimentNumber+"/"+counterString, counter);
  if (Firebase.getInt("LEDStatus"))

  {

    digitalWrite(LED, HIGH);

  }

  else

  {

    digitalWrite(LED, LOW);

  }

  if (Firebase.failed()) // Check for errors
  {

    Serial.print("setting /number failed:");

    Serial.println(Firebase.error());

    return;
  }

  
//
//  interval = num + 1;
counter=counter+interval;

  delay(1000);

}
