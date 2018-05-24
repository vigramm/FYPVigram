#include <WiFi.h>



/* Time Stamp */
#include <NTPClient.h>
#include <WiFiUdp.h>


#define NTP_OFFSET  +1  * 60 * 60 // In seconds
#define NTP_INTERVAL 60 * 1000    // In miliseconds
#define NTP_ADDRESS  "0.uk.pool.ntp.org"


const char* ssid = "Vigram's iPhone";
const char* password =  "abcdefgh";


WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, NTP_ADDRESS, NTP_OFFSET, NTP_INTERVAL);

void setup() {

   //Intializing the serial reader 
  Serial.begin(115200);

    //Connecting to WiFi
  WiFi.mode(WIFI_AP); 
  WiFi.begin(ssid, password); 

  //Loops and waits until Wifi is connected
  while (WiFi.status() != WL_CONNECTED) 
  { 
    delay(1000);
    // WiFi.begin(ssid, password); 
    Serial.println("Connecting to WiFi..");
  }
  // put your setup code here, to run once:
    timeClient.begin();
    timeClient.update();


}
int counter=0;
void loop() {
        timeClient.update();
      String formattedTime = timeClient.getFormattedTime();
      String json="{\n\""+String(counter)+"\" : "+10+",\n\"Time\" : \""+formattedTime+"\"\n}";

      Serial.println(json);

      counter++;
      delay(2000);
  // put your main code here, to run repeatedly:

}
