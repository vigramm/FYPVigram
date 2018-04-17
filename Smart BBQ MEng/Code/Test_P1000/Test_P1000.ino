


byte LED_BUILTIN2= 12;
int numReadings=20;




void setup() 
{
  Serial.begin(115200);
  pinMode(LED_BUILTIN2, OUTPUT);
 digitalWrite(LED_BUILTIN2, HIGH);
  
}


// the loop function runs over and over again forever
void loop() 
{
   
  float resistanceOfResistors=1000.0; //Voltage of Resistors
  float voltageReference=3.3; // Input Voltage on rails

  
  int total=0;

  float temp=0;
  for(int i=0;i<numReadings;i++)
  {
   // total=total+analogRead(A0);
    float sensorValue1=analogRead(A1); // Reading from the adc pin
    float voltageOutput1= sensorValue1 * 1.1425 *(voltageReference / 4095.0); // Convert analog value to voltage value(bridge)
    float resistancePt1000=voltageToResistancePotentialDivider(resistanceOfResistors, voltageReference, voltageOutput1); // Calculate resistance of Pt1000 using voltage from bridge
    Serial.println(resistancePt1000);
    temp=temp+GetPlatinumRTD(resistancePt1000);
    Serial.println(temp+14.0);
    delay(500);
  }

  
  temp=temp/numReadings;
  
  Serial.print("FINAAAL=== ");
  Serial.print(temp+14.0);



//
//  float sensorValue1=analogRead(A0); // Reading from the adc pin
//  float voltageOutput1= sensorValue1 * 1.1425 *(voltageReference / 4095.0); // Convert analog value to voltage value(bridge)
//  Serial.print("Value1= ");
//  Serial.println(voltageOutput1*1000); 
//
//  float resistancePt1000=voltageToResistancePotentialDivider(resistanceOfResistors, voltageReference, voltageOutput1); // Calculate resistance of Pt1000 using voltage from bridge
//  Serial.println(resistancePt1000);
//
//  float temp=GetPlatinumRTD(resistancePt1000);
//  Serial.println(temp);

  delay(2000);                      // Wait for a second
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
