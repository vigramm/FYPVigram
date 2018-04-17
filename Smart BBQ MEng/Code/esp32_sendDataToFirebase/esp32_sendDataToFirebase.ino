#include <WiFiClientSecure.h>

 
const char *ssid = "Vigram's iPhone"; 
const char *password = "abcdefgh";
 

 
String pres_str = "1";
String temp_str = "2";
String hum_str = "3";
 
//*************************************
void setup()
{
  Serial.begin(115200);
 
  delay(10);
 
  Serial.println();
  Serial.print(F("Connecting to "));
  Serial.println(ssid);
 
  WiFi.begin(ssid, password);
 
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 
  Serial.println();
  Serial.println(F("WiFi connected"));
  delay(1000);
 
  // Print the IP address
  Serial.println(WiFi.localIP());
 
  delay(2000);
 
 

  Firebase_Data_Send();

}


//**************************************
void loop(){


    Firebase_Data_Send();
    delay(1000);
}


//*************** HTTP GET **********************************************
void Firebase_Data_Send(){
  String ret_str = "";
 
  WiFiClientSecure client;
 
  const char *host = "smartbbq-9bfc3.firebaseio.com"; 
  if (client.connect(host, 443)) {
    //Serial.print(host); Serial.print(F("-------------"));
    //Serial.println(F("connected"));
    Serial.println(F("--------------------Realtime Database HTTP GET Request Send"));
 
    String str1 = "PUT /addMessage?text1=" + pres_str + "&text2=" + temp_str + "&text3=" + hum_str + " HTTP/1.1\r\n";
    String str2 = "Host: " + String(host) + "\r\n";
    String str3 = "Content-Type: text/html; charset=utf-8\r\n";
    String str4 = "Connection:close\r\n\r\n";
 
    client.print( str1 );
    client.print( str2 );
    client.print( str3 );
    client.print( str4 );

    Serial.println(F("--------------------Realtime Database HTTP Response"));
 
    char c;
    while(client.connected()){
      while (client.available()) {
        c = client.read();
//        Serial.print(c);
      }
      client.flush();
      delay(10);
      client.stop();
      delay(10);
      Serial.println(F("--------------------Client Stop"));
      break;
    }
 
  }else {
    // if you didn't get a connection to the server2:
    Serial.println(F("connection failed"));
  }
}
 


