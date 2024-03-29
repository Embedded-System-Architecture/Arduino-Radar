/*   Arduino Radar Project
 *  
 *   Modify by Zhaoran Wang 
 *   from Dejan Nedelkovski 
 *   at www.HowToMechatronics.com
 *   
 */

import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;

Serial myPort; // defines Object Serial
// defubes variables
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;
FloatList position = new FloatList();
float time = 0;

void setup() {
  
 size (1440, 1080); // ***CHANGE THIS TO YOUR SCREEN RESOLUTION***
 smooth();
 myPort = new Serial(this,"COM7", 9600); // starts the serial communication
 myPort.bufferUntil('.'); // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
 orcFont = loadFont("OCRAExtended-30.vlw");
}

void draw() {
  
  fill(98,245,31);
  textFont(orcFont);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0,4);
  rect(0, 0, width, height-height*0.065); 
  
  fill(98,245,31); // green color
  // calls the functions for drawing the radar
  drawRadar();
  drawLine();
  drawText();
  drawCircle();
  if(iAngle == 0 || iAngle == 360)
  {
    position.clear();
  }
}

void serialEvent (Serial myPort) { // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"
  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port
  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance
  
  // converts the String variables into Integer
  iAngle = int(angle);
  iDistance = int(distance);
}

void drawCircle(){
  pushMatrix();
  translate(width/2,height-height*0.53); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = iDistance*((height-height*0.1666)*0.0155); // covers the distance from the sensor from cm to pixels
  // limiting the range to 40 cms
  if(iDistance < 40){
    position.append(pixsDistance*cos(radians(iAngle)));
    position.append(-pixsDistance*sin(radians(iAngle)));
    }
  for(int i = 0; i < position.size(); i += 2)
    {
      fill(255, 0, 0);
      circle(position.get(i), position.get(i+1), 10);
    }
  popMatrix();
  
}

void drawRadar() {
  pushMatrix();
  translate(width/2,height-height*0.53); // moves the starting coordinats to new location
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // draws the arc lines
  
  arc(0,0,(width-width*0.40),(width-width*0.40),0,PI);
  arc(0,0,(width-width*0.55),(width-width*0.55),0,PI);
  arc(0,0,(width-width*0.70),(width-width*0.70),0,PI);
  arc(0,0,(width-width*0.85),(width-width*0.85),0,PI);
  
  arc(0,0,(width-width*0.40),(width-width*0.40),PI,TWO_PI);
  arc(0,0,(width-width*0.55),(width-width*0.55),PI,TWO_PI);
  arc(0,0,(width-width*0.70),(width-width*0.70),PI,TWO_PI);
  arc(0,0,(width-width*0.85),(width-width*0.85),PI,TWO_PI);
  // draws the angle lines
  line(-width/3,0,width/3,0);
  line(0,0,(-width/3.2)*cos(radians(30)),(-width/3.2)*sin(radians(30)));
  line(0,0,(-width/3.2)*cos(radians(60)),(-width/3.2)*sin(radians(60)));
  line(0,0,(-width/3.2)*cos(radians(90)),(-width/3.2)*sin(radians(90)));
  line(0,0,(-width/3.2)*cos(radians(120)),(-width/3.2)*sin(radians(120)));
  line(0,0,(-width/3.2)*cos(radians(150)),(-width/3.2)*sin(radians(150)));
  line((-width/3)*cos(radians(30)),0,width/3,0);
  
  //line(-width/2,0,width/2,0);
  line(0,0,(-width/3.2)*cos(radians(210)),(-width/3.2)*sin(radians(210)));
  line(0,0,(-width/3.2)*cos(radians(240)),(-width/3.2)*sin(radians(240)));
  line(0,0,(-width/3.2)*cos(radians(270)),(-width/3.2)*sin(radians(270)));
  line(0,0,(-width/3.2)*cos(radians(300)),(-width/3.2)*sin(radians(300)));
  line(0,0,(-width/3.2)*cos(radians(330)),(-width/3.2)*sin(radians(330)));
  //line((-width/2)*cos(radians(30)),0,width/2,0);
  
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width/2,height-height*0.074); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = iDistance*((height-height*0.1666)*0.025); // covers the distance from the sensor from cm to pixels
  // limiting the range to 40 cms
  if(iDistance<40){
  // draws the object according to the angle and the distance
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(width/2,height-height*0.53); // moves the starting coordinats to new location
  line(0,0,(height-height*0.49)*cos(radians(iAngle)),-(height-height*0.55)*sin(radians(iAngle))); // draws the line according to the angle
  popMatrix();
}

void drawText() { // draws the texts on the screen
  
  pushMatrix();
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(98,245,31);
  textSize(25);
  fill(98,245,60);
  translate(width-width * 0.153,height-height*0.526);
  //translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-90));
  text("0°",0,0);
  resetMatrix();
  
  //translate((width-width*0.656)+width/2*cos(radians(30)),(height-height*0.419)-width/2*sin(radians(30)));
  //rotate(-radians(-60));
  //text("30°",0,0);
  //resetMatrix();
  
  //translate((width-width*0.593)+width/2*cos(radians(60)),(height-height*0.3303)-width/2*sin(radians(60)));
  //rotate(-radians(-30));
  //text("60°",0,0);
  //resetMatrix();
  
  translate((width-width*0.510)+width/2*cos(radians(90)),(height-height*0.2883)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  
  //translate(width-width*0.422+width/2*cos(radians(120)),(height-height*0.3163)-width/2*sin(radians(120)));
  //rotate(radians(-30));
  //text("120°",0,0);
  //resetMatrix();
  
  //translate((width-width*0.3493)+width/2*cos(radians(150)),(height-height*0.3923)-width/2*sin(radians(150)));
  //rotate(radians(-60));
  //text("150°",0,0);
  //resetMatrix();
  
  translate(width-width * 0.842,height-height*0.510);
  //translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(90));
  text("180°",0,0);
  resetMatrix();
  
  translate((width-width*0.510)+width/2*cos(radians(90)),(height-height*0.0883));
  rotate(radians(0));
  text("270°",0,0);
  popMatrix(); 
  
}
