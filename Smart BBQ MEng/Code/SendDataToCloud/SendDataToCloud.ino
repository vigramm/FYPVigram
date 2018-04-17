#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
 





const char* ssid = "Vigram's iPhone";
const char* password = "abcdefgh";
 
void setup () {
 
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
 
}

void loop() {

  if (WiFi.status() == WL_CONNECTED) { //Check WiFi connection status
 
    HTTPClient http;  //Declare an object of class HTTPClient
 
    http.begin("https://pepper-2816119.eu-west-1.bonsaisearch.net/");  //Specify request destination
    int httpCode = http.GET();                                                                  //Send the request
       String payload = http.getString();   //Get the request response payload
      Serial.println(payload); 
    if (httpCode > 0) { //Check the returning code
 
      String payload = http.getString();   //Get the request response payload
      Serial.println(payload);                     //Print the response payload
 
    }
 
    http.end();   //Close connection
 
  }
 
  delay(30000);    //Send a request every 30 seconds

}
