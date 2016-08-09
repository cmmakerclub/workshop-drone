import controlP5.*;
import processing.serial.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.processing.*;

ToxiclibsSupport gfx;
ControlP5 cp5;
Serial port;                       
DropdownList serialPortsList;

int serialCount = 0;
int actual,integral,complementary,integral2,complementary2,error_integral,error_comple,gyro_offset,gyro_offset1,graph_scale,oldvalue_integral,oldvalue_comple,xPos;
String s = new String();
int[] i = new int[9];
int iCount = 0;
int iFPS;
int iFPSInput;
int interval = 0;
float gyro_scale = 32.8f,gyro_show1,gyro_show2;
PFont font, font2, font3, font4 ;
final int BAUD_RATE = 115200;
///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(960, 540, OPENGL);
  gfx = new ToxiclibsSupport(this);
  lights();
  smooth();
  cp5 = new ControlP5(this);
  // create a DropdownList
  String[] portNames = Serial.list();
  serialPortsList = cp5.addDropdownList("serial ports").setPosition(10, 10).setWidth(200);
  for (int i = 0; i < portNames.length; i++) serialPortsList.addItem(portNames[i], i);
  font = createFont("arial", 25); 
  font4 = createFont("arial", 20);
  font3 = createFont("arial", 30); 
  font2 = createFont("arial", 40);
  //String portName = Serial.list()[3];
  //port = new Serial(this, portName, 115200);
  graph_scale = 2;
  background(0);
}
void draw() {
  
  textAlign(CENTER);
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //[Reset Graph]
  //////////////////////////////////////////////////////////////////////////////////////////////////////
   if (xPos <= 700) {
    if (xPos == 0){
    pushMatrix();
    fill(0, 0, 0, 255);
    stroke(0,0,0); 
    beginShape();
    vertex(0,0);vertex(0,1000);vertex(1000,1000);vertex(1000,0);  // wing top layer
    endShape(CLOSE);
    popMatrix();
    }
    xPos++;
    if (xPos == 700){
    xPos = 0;
    }
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////  
  //[Object Actual]
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  pushMatrix(); // Set the background not to interferent 
  fill(0, 0, 0, 255);
  stroke(0, 0, 0); 
  beginShape();
  vertex(0, 0);
  vertex(0, 300);
  vertex(960, 300);
  vertex(960, 0);  // wing top layer
  endShape();
  popMatrix();
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(204, 0, 204);
  //stroke(204,0,204);
  noStroke();
  pushMatrix();
  rect(160, 110, 40, 150);
  popMatrix();
  pushMatrix();
  translate(180, 130);
  textFont(font);
  //text(angle,200,200);
  rotateZ(actual/180.0f*PI);
  fill(255, 0, 0, 200);
  noStroke();
  box(250, 8, 0);
  popMatrix();
  fill(205, 205, 205);
  noStroke();
  ellipse(180, 130, 25, 25);
  textFont(font4);
  text("Actual",180,40);
  fill(255,0,0);
  text(actual,180,70);
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  //[Object Integral]
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(204, 0, 204);
  noStroke();
  pushMatrix();
  rect(460, 110, 40, 150);
  popMatrix();
  pushMatrix();
  translate(480, 130);
  textFont(font);
  //text(angle,200,200);
  rotateZ(integral/180.0f*PI);
  fill(0, 0, 255, 200);
  noStroke();
  box(250, 8, 0);
  popMatrix();
  fill(205, 205, 205);
  noStroke();
  ellipse(480, 130, 25, 25);
  textFont(font4);
  text("Integral",480,40);
  fill(0,0,255);
  text(integral,480,70);
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //[Object Complementary]
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(204, 0, 204);
  noStroke();
  pushMatrix();
  rect(760, 110, 40, 150);
  popMatrix();
  pushMatrix();
  translate(780, 130);
  textFont(font);
  //text(angle,200,200);
  rotateZ(complementary/180.0f*PI);
  fill(0, 255, 0, 200);
  noStroke();
  box(250, 8, 0);
  popMatrix();
  fill(205, 205, 205);
  noStroke();
  ellipse(780, 130, 25, 25);
  textFont(font4);
  text("Complementary",780,40);
  fill(0,255,0);
  text(complementary,780,70);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  //[Gyro]
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(255,255,255);
  noStroke();
  gyro_show1 = gyro_offset/32.8f;
  gyro_show2 = gyro_offset1/32.8f;
  textFont(font4);
  text("Gyro",345,290);
  text(nf(gyro_show1,1,2),410,290);
  text("Gyro offset",565,290);
  text(nf(gyro_show2,1,2),660,290);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  //[Graph]
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
    pushMatrix();
  //fill(0, 0, 0, 255);
  //stroke(0,0,0); 
  //beginShape();
  //vertex(500,0,0);vertex(500,400,0);vertex(1000,400,0);vertex(1000,0,0);  // wing top layer
  //endShape(CLOSE);
  stroke(255,255,255);
  line(100,320,100,520);
  line(100,420,800,420);
  line(90,320,110,320);
  line(90,370,110,370);
  line(90,470,110,470);
  line(90,520,110,520);
  
  fill(255,255,255);
  textFont(font4);
  text("Angle",65,290);
  pushMatrix();
  fill(0, 0, 0, 255);
  stroke(0,0,0); 
  beginShape();
  vertex(0,300);vertex(80,300);vertex(80,540);vertex(0,540);  // wing top layer
  endShape(CLOSE);
  popMatrix();
  fill(255,255,255);
  textFont(font4);
  text("50",65,325);
  text("25",65,375);
  text("0",65,425);
  text("-25",65,475);
  text("-50",65,525);  
  pushMatrix();
  fill(0, 0, 0, 255);
  stroke(0,0,0); 
  beginShape();
  vertex(800,300);vertex(960,300);vertex(960,540);vertex(800,540);  // wing top layer
  endShape(CLOSE);
  popMatrix();
  stroke(0,0,255);
  line(800,400,850,400);
  fill(255,255,255);
  textFont(font4);
  text("Integral",900,405);
  
  stroke(0,255,0);
  line(800,450,850,450);
  fill(255,255,255);
  textFont(font4);
  text("Compleme.",910,455);
  
  integral2 = graph_scale*integral;
  stroke(0,0,255);
  strokeWeight(2 );
  line((100+xPos),420-oldvalue_integral,100+xPos+1,420-integral2);
  oldvalue_integral = integral2;

  complementary2 = graph_scale*complementary;
  stroke(0,255,0);
  strokeWeight(2);
  line((100+xPos),420-oldvalue_comple,100+xPos+1,420-complementary2);
  oldvalue_comple = complementary2;
  popMatrix();
}
void serialEvent(Serial port) {
  //interval = millis();
  while (port.available() > 0) {
    int ch = port.read();
    println(s);
    if (ch == '\n') {
      s = trim(s);
      i = int(split(s, ','));
      if (i.length == 9) {
        actual = i[1]; 
        integral = i[2]; 
        complementary = i[3]; 
        error_integral = i[4]; 
        error_comple = i[5]; 
        gyro_offset = i[6]; 
        gyro_offset1 = i[7];
                
        port.clear();
      }
      //
      s = "";
    } else {
      s += char(ch);
      //println(s.length());
    }
  }
}
void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    //check if there's a serial port open already, if so, close it
    //if (serialPort != null) {
    //  serialPort.stop();
    //  serialPort = null;
    //}
    //open the selected core
    //portName = serialPortsList.getItem((int)theEvent.getValue());
    //String portName = Serial.list()[0];
    //print(select_port);
    //println(portName);
    //try {
    //  serialPort = new Serial(this, portName, BAUD_RATE);
    //}
    //catch(Exception e) {
    //  System.err.println("Error opening serial port " + portName);
    //  e.printStackTrace();
    //}
  } else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    println(theEvent.getController().getValue());
    String portName = Serial.list()[(int)theEvent.getController().getValue()];
    println(portName);
    try {
      port = new Serial(this, portName, BAUD_RATE);
    }
    catch(Exception e) {
      System.err.println("Error opening serial port " + portName);
      e.printStackTrace();
    }
  }
}