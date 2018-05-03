byte motorPin = 12;


void setup()
{
  Serial.begin(115200);
  //set motorPin as OUTPUT
  pinMode(motorPin, OUTPUT);




}
void loop()
{
   motorOnThenOff();
   Serial.print("1");
}
// This function turns the motor on and off like the blinking LED.
// Try different values to affect the timing.
void motorOnThenOff()
{
  // turn the motor on (full speed)
  digitalWrite(motorPin, HIGH); 
  // delay for onTime milliseconds
  delay(2000);     
  // turn the motor off
  digitalWrite(motorPin, LOW);  
  // delay for offTime milliseconds
  delay(5000            );               
}

