#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

/* Time Stamp */
#include <NTPClient.h>
#include <WiFiUdp.h>

#define NTP_OFFSET  +1  * 60 * 60 // In seconds
#define NTP_INTERVAL 60 * 1000    // In miliseconds
#define NTP_ADDRESS  "0.uk.pool.ntp.org"

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, NTP_ADDRESS, NTP_OFFSET, NTP_INTERVAL);



const char* ssid = "Vigram's iPhone";
const char* password =  "abcdefgh";

byte VoltageOutput= 12;
byte battery=35;
byte WifiLedIndicator= 14;
int numReadings=20;
int experimentNumber;
int counter=0;

void setup() 
{

  //Intializing the serial reader 
  Serial.begin(115200);

  //Initializing the output voltage pin
  pinMode(VoltageOutput, OUTPUT);

  //Initializing the led indicator pin that is on when wifi is connected 
  pinMode(WifiLedIndicator, OUTPUT);

  //Making output voltage pin HIGH
 digitalWrite(VoltageOutput, HIGH);

  //Delay to ensure above is set up before attempting connection to wifi
  delay(4000);   

  //Connecting to WiFi
  WiFi.mode(WIFI_AP); 
  WiFi.mode(WIFI_AP_STA);
  WiFi.begin(ssid, password); 

  //Loops and waits until Wifi is connected
  while (WiFi.status() != WL_CONNECTED) 
  { 
    delay(1000);
    // WiFi.begin(ssid, password); 
    Serial.println("Connecting to WiFi..");
  }

  // Making WifiIndicator Pin high as wifi will be connected once the program reaches here
  digitalWrite(WifiLedIndicator, HIGH);
  Serial.println("Connected to the WiFi network");


  timeClient.begin();
  


   
}



void loop() {

    HTTPClient http;

    //variable to keep track if the EspMode(Start or End)
    String ESPmode="";

    //GET mode from database
    http.begin("https://smartbbq-9bfc3.firebaseio.com/Mode.json"); 
    int httpCode = http.GET();                                      
    if (httpCode > 0) 
    { 
      ESPmode= http.getString();
        Serial.println(httpCode);
        Serial.println(ESPmode);
    }
    else 
    {
      Serial.println("Error on HTTP request");
    }
 
    http.end(); //Free the resources


    //Check if ESP is in Start Mode, temperature data will be recorded only if esp is in start mode
    if(ESPmode.equals("\"Start\""))
    {
        //Initializing http object
  HTTPClient http;

  // Connecting to the database to get the total number of experiments conducted as of now
  // We now have exprimentNumber
  http.begin("https://smartbbq-9bfc3.firebaseio.com/TotalExperiments.json"); 
  int httpCode = http.GET();                                     
  if (httpCode > 0) //Check for the returning code, <0 is an error
  {
    experimentNumber=http.getString().toInt();
    //        Serial.println(httpCode);
    //        Serial.println(experimentNumber);
  }
  else 
  {
    Serial.println("Error on HTTP request");
  }
 
  http.end(); //Free the resources

      
      //Get current time
      timeClient.update();
      String formattedTime = timeClient.getFormattedTime();
      Serial.print(formattedTime);

      http.begin("https://smartbbq-9bfc3.firebaseio.com/CurrentExperimentCounter.json"); 
       httpCode = http.GET();                                     
      if (httpCode > 0) //Check for the returning code, <0 is an error
      {
        counter= (http.getString().toInt())+1;
      }
      else 
      {
        Serial.println("Error on HTTP request");
      }
      http.end();

    

      
      // Temperature will only be recorded if ESP is connected to Wifi
      if(WiFi.status()== WL_CONNECTED)
      {   
        float resistanceOfResistors=1000.0; //Voltage of Resistors
        float voltageReference=2.7; // Input Voltage on rails
        int total=0;
        float temp=0;

        float sensorValueTotal=0;
        // For loop to average over x number of readings
        for(int i=0;i<numReadings;i++)
        {
          float sensorValue1=analogRead(32); // Reading from the adc pin
          sensorValueTotal=sensorValueTotal+sensorValue1;
          Serial.print("SensorValue"+String(sensorValueTotal));
          float voltageOutput1= sensorValue1 * 1.1425 *(voltageReference / 4095.0); // Convert analog value to voltage value(bridge)
          float resistancePt1000=voltageToResistancePotentialDivider(resistanceOfResistors, voltageReference, voltageOutput1); // Calculate resistance of Pt1000 using voltage from bridge
//          Serial.println("Resistance= "+String(resistancePt1000));
          temp=temp+GetPlatinumRTD(resistancePt1000);
//          Serial.println("Temp= "+String(temp+14.0));
          delay(500);
        }

        sensorValueTotal=sensorValueTotal/numReadings;
        
        // Finding the average of the x readings
        temp=temp/numReadings;
        Serial.print("FINAL temp= ");

        // This makes the temperature readings accurate
        float finaltemp=temp+24.0;
        Serial.print(temp+24.0);
        Serial.println();

  
        //POST to the database
        HTTPClient http; 
        //String json="{\n\"Value\" : "+String(finaltemp)+",\n\"Time\" : \""+formattedTime+"\"\n}";
        String json="{\n\"Value\" : "+String(finaltemp)+",\n\"Time\" : \""+formattedTime+"\",\n\"SensorValue\" : "+String(sensorValueTotal)+"\n}";


        Serial.print(json);
        HTTPRequest("https://smartbbq-9bfc3.firebaseio.com/experiment"+String(experimentNumber)+"/"+String(counter)+".json", json, "PATCH");


//        json="{\n\""+String(counter)+"\" : "+String(now)+"\n}";
//        Serial.print(json);
//        HTTPRequest("https://smartbbq-9bfc3.firebaseio.com/experiment"+String(experimentNumber)+".json", json, "PATCH");

         //POST current counter 
        json="{\n\"CurrentExperimentCounter\" : "+String(counter)+"\n}";
        
        HTTPRequest("https://smartbbq-9bfc3.firebaseio.com/.json", json, "PATCH");

        
        counter++;

        //GET battery value
        float batteryvalue=analogRead(battery);
        //  Serial.println(batteryvalue);
        float batteryOutput=batteryvalue*1.1425*3.3/4095*2;
        //  Serial.println(batteryOutput);
        int batterypercent=(int)(batteryOutput/3.8*100);
        //  Serial.println(batterypercent);



        //POST battery percentage
        json="{\n\"batteryPercent\" : "+String(batterypercent)+"\n}";
        HTTPRequest("https://smartbbq-9bfc3.firebaseio.com/.json", json, "PATCH");

   
 
     }
     else
     {
      //Switch off led indicator
      digitalWrite(WifiLedIndicator, LOW);
   
      Serial.println("Error in WiFi connection");   
      WiFi.mode(WIFI_AP); // workaround
      WiFi.mode(WIFI_AP_STA);
      WiFi.begin(ssid, password); 
      while (WiFi.status() != WL_CONNECTED) 
      { //Check for the connection
        delay(1000);
        Serial.println("Connecting to WiFi..");
      }
      Serial.println("Connected to the WiFi network");
     }
   }
   // If Mode is not "Start"
   else
   {
    ESP.restart();
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
    
    float numerator=voltageOutput*resistanceOfResistors;
    float denominator=voltageInput-voltageOutput;

    float resistancePT1000=numerator/denominator;

    return resistancePT1000;
    
}

//Convert resistance to temperature
float GetPlatinumRTD(float R) { 
   float A=3.90802E-03; 
   float B=-5.80195E-07; 
   float R0=1000.00; 

  float D=(A*A*R0*R0)-(4*R0*B*(R0-R));
  float numerator=-(R0*A)+sqrt(D);
  float denominator=(2*R0*B);

  float root=numerator/denominator;
  Serial.print("Root= ");
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

void HTTPRequest(String httpAddress, String json,  String requestType)
{
  HTTPClient http;
  http.begin(httpAddress);
  http.addHeader("Content-Type", "application/json");             //Specify content-type header
  int httpResponseCode;
  if(requestType.equals("PATCH"))
  {
    httpResponseCode = http.sendRequest("PATCH", json);   //Send the actual POST request
  }
  else if(requestType.equals("GET"))
  {
    httpResponseCode = http.sendRequest("GET", json);   //Send the actual POST request
  }
  else if(requestType.equals("POST"))
  {
    httpResponseCode = http.sendRequest("POST", json);   //Send the actual POST request
  }
  delay(1000);       
  if(httpResponseCode>0)
  {
    String response = http.getString();       
    //    Serial.println(httpResponseCode);   //Print return code
    //    Serial.println(response);           //Print request answer     
   }
   else
   {
    Serial.print("Error on sending POST: ");
    Serial.println(httpResponseCode);     
   }
}

