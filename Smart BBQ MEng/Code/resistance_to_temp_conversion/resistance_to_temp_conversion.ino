void setup() {
  // put your setup code here, to run once:
  
}

void loop() {

  
  // put your main code here, to run repeatedly:

}

//http://forum.arduino.cc/index.php?topic=43605.0 

float GetPlatinumRTD(float R,float R0) { 
   float A=3.9083E-3; 
   float B=-5.775E-7; 
   float T; 
   
   R=R/R0; 
   
   //T = (0.0-A + sqrt((A*A) - 4.0 * B * (1.0 - R))) / 2.0 * B; 
   T=0.0-A; 
   T+=sqrt((A*A) - 4.0 * B * (1.0 - R)); 
   T/=(2.0 * B); 
   
   if(T>0&&T<200) { 
     return T; 
   } 
   else { 
     //T=  (0.0-A - sqrt((A*A) - 4.0 * B * (1.0 - R))) / 2.0 * B; 
     T=0.0-A; 
     T-=sqrt((A*A) - 4.0 * B * (1.0 - R)); 
     T/=(2.0 * B); 
     return T; 
   } 
} 
