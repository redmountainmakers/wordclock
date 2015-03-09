/* 
  This sketch uses the Bean library to blink the on-board RGB LED. 
  
  Notes:
    - This is not a low-power sketch 
    - A Bean with a low battery might show a faint blue and green LED color
  
  This example code is in the public domain.
*/

int ledGreenPin = 0;
int switchMinsPin = A0;
int switchHrsPin = A1;

void setup() {
  // initialize serial communication
    Serial.begin(57600);
    pinMode(ledGreenPin, OUTPUT);     // set D0 as output
    pinMode(switchMinsPin, INPUT);
    pinMode(switchHrsPin, INPUT);
    digitalWrite(ledGreenPin, LOW);   // turn it off initially
}

void loop() {
  digitalWrite(ledGreenPin, LOW);
  Bean.setLed(0,0,0);
  
  int minsTick = digitalRead(switchMinsPin);
  int hrsTick  = digitalRead(switchHrsPin);
  
  Serial.print("Hours = ");
  Serial.print(hrsTick);
  Serial.print("  Mins = ");
  Serial.println(minsTick);
   
  digitalWrite(ledGreenPin, minsTick);
  int red = hrsTick == HIGH ? 255 : 0;
  Bean.setLed(0,0,red);
  Bean.sleep(200);
}
