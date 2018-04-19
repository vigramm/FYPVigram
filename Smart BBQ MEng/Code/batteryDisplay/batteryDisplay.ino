
byte battery = 35;  // Huzzah32 Battery Voltage is on Pin 35



void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

}

void loop() {
  // put your main code here, to run repeatedly:
  float batteryvalue=analogRead(battery);
  Serial.println(batteryvalue);
  float batteryOutput=batteryvalue*1.1425*3.3/4095*2;
  Serial.println(batteryOutput);
  float batterypercent=batteryOutput/3.7*100;
  Serial.println(batterypercent);

  delay(2000);
}
