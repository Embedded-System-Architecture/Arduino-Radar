// Includes the Servo library
#include <Servo.h>

// Defines Tirg and Echo pins of the Ultrasonic Sensor
const int trigPin1 = 10;
const int echoPin1 = 11;

// Variables for the duration and the distance
long duration;
int distance;
Servo myServo1; // Creates a servo object for controlling the servo motor
Servo myServo2; // Creates a servo object for controlling the servo motor

void setup() {
  pinMode(trigPin1, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin1, INPUT); // Sets the echoPin as an Input
  
  Serial.begin(9600);
  
  // Defines on which pin is the servo motor attached
  myServo1.attach(6); // Defines on which pin is the servo motor attached
  myServo2.attach(9);
  myServo1.write(0);
  myServo2.write(0);
  delay(100);
}
void loop() {
  
  // rotates the servo1 motor from 0 to 180 degrees
  for(int i=0;i<=180;i++)
  {
  myServo1.write(i);
  delay(30); 
  distance = calculateDistance();// Calls a function for calculating the distance measured by the Ultrasonic sensor for each degree
  Serial.print(i); // Sends the current degree into the Serial Port
  Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  Serial.print(distance); // Sends the distance value into the Serial Port
  Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  }
  
  delay(30);

  // rotates the servo2 motor from 180 to 360 degrees
  for(int i=0;i<=180;i++)
  {
  myServo2.write(i);
  distance = calculateDistance();// Calls a function for calculating the distance measured by the Ultrasonic sensor for each degree
  delay(30); 
  Serial.print(i + 180); // Sends the current degree into the Serial Port
  Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  Serial.print(distance); // Sends the distance value into the Serial Port
  Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  }
  
  delay(30);
  
  // rotates the servo2 motor from 360 to 180 degrees
  for(int i=180;i>0;i--)
  {
  myServo2.write(i);
  delay(30);
  distance = calculateDistance();
  Serial.print(i + 180); // Sends the current degree into the Serial Port
  Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  Serial.print(distance); // Sends the distance value into the Serial Port
  Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  }
  
  delay(30);
  
  // rotates the servo1 motor from 180 to 0 degrees
  for(int i=180;i>0;i--)
  {
  myServo1.write(i);
  delay(30);
  distance = calculateDistance();
  Serial.print(i); // Sends the current degree into the Serial Port
  Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  Serial.print(distance); // Sends the distance value into the Serial Port
  Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  }
  
}
// Function for calculating the distance measured by the Ultrasonic sensor
int calculateDistance(){ 
  
  digitalWrite(trigPin1, LOW); 
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin1, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin1, LOW);
  duration = pulseIn(echoPin1, HIGH); // Reads the echoPin, returns the sound wave travel time in microseconds
  distance= duration*0.034/2;
  return distance;
}
