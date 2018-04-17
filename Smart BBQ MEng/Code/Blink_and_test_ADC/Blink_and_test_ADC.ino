

void setup() {
  pinMode(D0, OUTPUT); // Initialize the LED_BUILTIN pin as an output
  Serial.begin(9600);
}

// the loop function runs over and over again forever
void loop() 
{
  digitalWrite(D0, LOW);   // Turn the LED on (Note that LOW is the voltage level
                                    // but actually the LED is on; this is because 
                                    // it is acive low on the ESP-01)
  Serial.println("hello");
  Serial.println(analogRead(A0)); // Testing the adc pin
  
  delay(1000);                      // Wait for a second
  digitalWrite(D0, HIGH);  // Turn the LED off by making the voltage HIGH
  delay(500);                      // Wait for two seconds (to demonstrate the active low LED)
}
