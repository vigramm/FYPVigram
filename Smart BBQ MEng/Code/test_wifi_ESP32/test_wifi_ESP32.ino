#include <Firebase.h>
#include <FirebaseArduino.h>
#include <FirebaseCloudMessaging.h>
#include <FirebaseError.h>
#include <FirebaseHttpClient.h>
#include <FirebaseObject.h>


#include <WiFi.h>


// Define the ID and password of your Wi-Fi network
const char* ssid = "Vigram's iPhone";
const char* password = "abcdefgh";



#define FIREBASE_HOST "smartbbq-9bfc3.firebaseio.com"

#define FIREBASE_AUTH "XL5osW1DYgFpRBEcmEBTERisMDvZCEVCwfnfBd6s"

int counter = 1;
int interval = 1;


void setup(void) {
 
  // Start the Serial communication for debugging purposes
  Serial.begin(115200);
  
  //  Initialize the WiFi client and try to connect to our Wi-Fi network
  WiFi.begin(ssid, password);
  Serial.println("");

  // Wait for a successful connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  // For debugging purposes print the network ID and the assigned IP address
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}


void loop() {

  String ExperimentNumber="Experiment1";
  String counterString = String(counter);

  Firebase.setInt(ExperimentNumber+"/"+counterString, counter);

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
