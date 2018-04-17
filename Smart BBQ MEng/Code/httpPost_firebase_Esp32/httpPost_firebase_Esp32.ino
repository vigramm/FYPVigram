#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>


const char* ssid = "Vigram's iPhone";
const char* password =  "abcdefgh";

//char PostData[] = "{\"name\": \"Fred\", \"age\": 31}";

void setup() {
 
  Serial.begin(115200);
  Serial.setDebugOutput(true);
  delay(4000);   //Delay needed before calling the WiFi.begin
 
  WiFi.mode(WIFI_AP); // workaround
  WiFi.mode(WIFI_AP_STA);
  WiFi.begin(ssid, password); 
  
  while (WiFi.status() != WL_CONNECTED) { //Check for the connection
    delay(1000);
   // WiFi.begin(ssid, password); 
    Serial.println("Connecting to WiFi..");
  }
 
  Serial.println("Connected to the WiFi network");
 
}

int counter=0;

void loop() {

  Serial.println(1);
 
 if(WiFi.status()== WL_CONNECTED){   //Check WiFi connection status


  StaticJsonBuffer<300> JSONbuffer;   //Declaring static JSON buffer
    JsonObject& JSONencoder = JSONbuffer.createObject(); 
 
   String json="{\n\""+String(counter)+"\" : 2\n}";
    Serial.print(json);

    counter++;
 
   
 
    char JSONmessageBuffer[300];
    JSONencoder.prettyPrintTo(JSONmessageBuffer, sizeof(JSONmessageBuffer));
    Serial.println(JSONmessageBuffer);
   HTTPClient http;   
 
   http.begin("https://smartbbq-9bfc3.firebaseio.com/experiment1.json");  //Specify destination for HTTP request
   http.addHeader("Content-Type", "application/json");             //Specify content-type header
 
   int httpResponseCode = http.sendRequest("PATCH", json);   //Send the actual POST request

   delay(1000);
 
   if(httpResponseCode>0){
 
    String response = http.getString();                       //Get the response to the request
 
    Serial.println(httpResponseCode);   //Print return code
    Serial.println(response);           //Print request answer
 
   }else{
 
    Serial.print("Error on sending POST: ");
    Serial.println(httpResponseCode);
 
   }
 
   http.end();  //Free resources
 
 }else{
 
    Serial.println("Error in WiFi connection");   
    WiFi.mode(WIFI_AP); // workaround
    WiFi.mode(WIFI_AP_STA);
    WiFi.begin(ssid, password); 
    while (WiFi.status() != WL_CONNECTED) { //Check for the connection
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }
 
  Serial.println("Connected to the WiFi network");
  
  
}
 

 
  delay(1000);  //Send a request every 10 seconds
  
}
