#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>


const char* ssid = "Vigram's iPhone";
const char* password =  "abcdefgh";

byte LED_BUILTIN2= 12;
byte WifiLedIndicator= 14;

int numReadings=20;

//char PostData[] = "{\"name\": \"Fred\", \"age\": 31}";

void setup() {
 
  Serial.begin(115200);
    pinMode(LED_BUILTIN2, OUTPUT);
    pinMode(WifiLedIndicator, OUTPUT);

 digitalWrite(LED_BUILTIN2, HIGH);
  delay(4000);   //Delay needed before calling the WiFi.begin
 
  WiFi.mode(WIFI_AP); // workaround
  WiFi.mode(WIFI_AP_STA);
  WiFi.begin(ssid, password); 
  
  while (WiFi.status() != WL_CONNECTED) { //Check for the connection
    delay(1000);
   // WiFi.begin(ssid, password); 
    Serial.println("Connecting to WiFi..");
  }

 digitalWrite(WifiLedIndicator, HIGH);
   Serial.println("Connected to the WiFi network");
 
}

int counter=0;

void loop() {
   
 if(WiFi.status()== WL_CONNECTED){   //Check WiFi connection status

  float resistanceOfResistors=1000.0; //Voltage of Resistors
  float voltageReference=3.3; // Input Voltage on rails

  
  int total=0;

  float temp=0;
  for(int i=0;i<numReadings;i++)
  {
   // total=total+analogRead(A0);
    float sensorValue1=analogRead(32); // Reading from the adc pin
    float voltageOutput1= sensorValue1 * 1.1425 *(voltageReference / 4095.0); // Convert analog value to voltage value(bridge)
    float resistancePt1000=voltageToResistancePotentialDivider(resistanceOfResistors, voltageReference, voltageOutput1); // Calculate resistance of Pt1000 using voltage from bridge
    Serial.println(resistancePt1000);
    temp=temp+GetPlatinumRTD(resistancePt1000);
    Serial.println(temp+14.0);
    delay(500);
  }

  
  temp=temp/numReadings;
  
  Serial.print("FINAAAL=== ");
  float finaltemp=temp+14.0;
  Serial.print(temp+14.0);

  StaticJsonBuffer<300> JSONbuffer;   //Declaring static JSON buffer
    JsonObject& JSONencoder = JSONbuffer.createObject(); 
 
   String json="{\n\""+String(counter)+"\" : "+finaltemp+"\n}";
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
   digitalWrite(WifiLedIndicator, LOW);
 
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
 

 
  delay(2000);  //Send a request every 10 seconds
  
}


// Converts bridge voltage to resistance
float voltageToResistance(float resistanceOfResistors, float voltageInput, float bridgeOutput)
{
    float numerator=voltageInput+(2*bridgeOutput);
    float denominator=voltageInput-(2*bridgeOutput);

    float resistancePT1000=resistanceOfResistors*numerator/denominator;

    return resistancePT1000;
    
}


// Use when calculating using potential divider
float voltageToResistancePotentialDivider(float resistanceOfResistors, float voltageInput, float voltageOutput)
{
    Serial.println(voltageOutput);
    float numerator=voltageOutput*resistanceOfResistors;
    float denominator=voltageInput-voltageOutput;

    float resistancePT1000=numerator/denominator;

    return resistancePT1000;
    
}


float GetPlatinumRTD(float R) { 
   float A=3.90802E-03; 
   float B=-5.80195E-07; 
   float R0=1000.00; 

  float D=(A*A*R0*R0)-(4*R0*B*(R0-R));
  float numerator=-(R0*A)+sqrt(D);
  float denominator=(2*R0*B);

  float root=numerator/denominator;
  Serial.println("Root= ");
  Serial.println(root);
   
//   R=R/1000; 
//   
//   //T = (0.0-A + sqrt((A*A) - 4.0 * B * (1.0 - R))) / 2.0 * B; 
//   T=0.0-A; 
//   T+=sqrt((A*A) - 4.0 * B * (1.0 - R)); 
//   T/=(2.0 * B); 
//   
//   if(T>0&&T<200) { 
//     return T; 
//   } 
//   else { 
//     //T=  (0.0-A - sqrt((A*A) - 4.0 * B * (1.0 - R))) / 2.0 * B; 
//     T=0.0-A; 
//     T-=sqrt((A*A) - 4.0 * B * (1.0 - R)); 
//     T/=(2.0 * B); 
     return root; 
//   } 
} 