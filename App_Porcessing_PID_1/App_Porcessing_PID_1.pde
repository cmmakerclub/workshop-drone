import controlP5.*;
import processing.serial.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.processing.*;
//import java.text.DecimalFormat;
//import java.lang.String;
DropdownList serialPortsList;
ToxiclibsSupport gfx;
ControlP5 cp5;
Serial port;                         // The serial port
////////////////////////////////////////////////////////////////////////////////////////////////////////////
int serialCount = 0;
int motor_a = 0, motor_b = 0, angle,angle2, angle_offset,angle_offset2, kp, ki, kd,aligned1,data,xPos = 0,oldvalue_angle,oldvalue_angleoffset;
String s = new String();
int[] i = new int[9];
int iCount = 0;
int iFPS;
int iFPSInput;
int interval = 0;

float angle_scale = 2.5f;
PFont font,font2,font3,font4 ;
final int BAUD_RATE = 115200;

void setup() {
  // 300px square viewport using OpenGL rendering
  size(1000, 600, OPENGL);
  gfx = new ToxiclibsSupport(this);
  lights();
  smooth(2);
  //println(Serial.list());
  //String portName = Serial.list()[2];
  //port = new Serial(this, portName, 115200);
  font = createFont("arial", 25); 
  font4 = createFont("arial", 20);
  font3 = createFont("arial", 30);
  font2 = createFont("arial", 40);
  String[] portNames = Serial.list();
  cp5 = new ControlP5(this);
  // create a DropdownList
  serialPortsList = cp5.addDropdownList("serial ports").setPosition(5, 5).setWidth(150);
  for (int i = 0; i < portNames.length; i++) serialPortsList.addItem(portNames[i], i);

}
void draw(){
  //background(0);
   if (millis() - interval > 2000) {
    interval = millis();
    iFPS = iCount;
    iCount = 0;
   }
   iCount++;
  //pushMatrix();
  //fill(0, 0, 0);
  //stroke(0,0,0);
  //beginShape(QUADS);
  //vertex(0, 0); 
  //vertex(0, 1000); 
  //vertex(1000, 1000); 
  //vertex(1000, 0);
  //endShape();
  //popMatrix();
  textAlign(CENTER);

  if (xPos <= 400) {
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
    if (xPos == 400){
    xPos = 0;
    }
    }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  pushMatrix();
  fill(0, 0, 0, 255);
  stroke(0,0,0); 
  beginShape();
  vertex(0,0);vertex(0,400);vertex(540,400);vertex(540,0);  // wing top layer
  endShape();
  popMatrix();
  fill(204,0,204);
  stroke(204,0,204);
  pushMatrix();
  rect(250,180,40,150);
  popMatrix();
  pushMatrix();
  translate(270, 200);
  textFont(font);
  //text(angle,200,200);
  rotateZ(-angle/180.0f*PI);
  fill(0, 255, 0, 200);
  stroke(0,0,0);
  box(350,5,0);
  line(50,50,100,100);
  popMatrix();
  fill(205,205,205);
  //stroke(205,205,205);
  //pushMatrix();
  ellipse(270,200,25,25);
  //popMatrix();
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  pushMatrix();
  fill(255,255,0);
  rect(40,200, 30, -10-(motor_a));  
  fill(0,255,255);
  rect(460,200, 30, -10-(motor_b));  
  fill(255,0,255);
  //PFont font = createFont("arial", 30);
  fill(255,255,255,255);
  
  textFont(font);
  text(motor_a,54,230);
  textFont(font);
  text(motor_b,475,230); 
  popMatrix();
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  pushMatrix();
  //fill(0, 0, 0, 255);
  //stroke(0,0,0); 
  //beginShape();
  //vertex(500,0,0);vertex(500,400,0);vertex(1000,400,0);vertex(1000,0,0);  // wing top layer
  //endShape(CLOSE);
  stroke(255,255,255);
  line(550,100,550,300);
  line(550,200,950,200);
  line(540,100,560,100);
  line(540,300,560,300);
  line(540,250,560,250);
  line(540,150,560,150);
  
  textFont(font4);
  text("Angle",510,75);
  text("40",510,105);
  text("20",510,155);
  text("0",510,205);
  text("-20",510,255);
  text("-40",510,305);
  stroke(255,0,0);
  strokeWeight(2);
  //println(xPos);
  angle2 = (int)angle_scale  * angle;
  line(550+xPos,200-oldvalue_angle,(550+xPos+1),200-angle2);
  line(800,350,850,350);
  oldvalue_angle = angle2;

  stroke(255,255,255);
 
  textFont(font4);
    fill(0,0,0);
  text("Angle",900,355);
    text("Angle",900,355);

      fill(255,255,255);

  text("Angle",900,355);
  //println(error);
  //println(oldvalue_error);
  angle_offset2 = (int)angle_scale  * angle_offset;
  stroke(0,255,0);
  strokeWeight(2);
  line(550+xPos,200-oldvalue_angleoffset,(550+xPos+1),200-angle_offset2);
  line(800,380,850,380);
  oldvalue_angleoffset = angle_offset2;
  stroke(255,255,255);
  textFont(font4);
  fill(0,0,0);
  text("Setpoint",900,385);
    text("Setpoint",900,385);

  text("time",900,220);
    text("time",900,220);

  //text("FPS : "+iFPS,50,100);

    fill(255,255,255);
  text("Setpoint",900,385);

  text("time",900,220);
  //text("FPS : "+iFPS,50,100);
  popMatrix();
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  //textFont(font);
  //text("Error",250,250);
  
  fill(0, 0, 0);
  stroke(0,0,0);
  fill(0,0,0);
  stroke(0,0,0);
  strokeWeight(1);
  pushMatrix();
  beginShape(QUADS);
  vertex(0, 400); 
  vertex(600, 400); 
  vertex(600, 700); 
  vertex(0, 700);
  endShape();
  
    fill(255,255,255);

    textFont(font4);
  text("Angle",220,30);
  text("Setpoint",320,30);
  textFont(font3);
  
  fill(0,255,0);
  stroke(0,255,0);
  text(angle_offset,320,70);
  
  fill(255,0,0);
  stroke(255,0,0);
  text(angle,220,70);

  
  fill(255,255,255);
  stroke(255,255,255);
  textFont(font2);
  text("PID Parameter",150,450);
  text("Kp",40,550);
  text(kp,120,550);
  text("Ki",190,550);
  text(ki,270,550);
  text("Kd",350,550);
  text(kd,450,550);
  popMatrix();
  //delay(20);
}

void serialEvent(Serial port) {
  //interval = millis();
    while (port.available() > 0) {
        int ch = port.read();
        //println(s);
        if(ch == '\n'){
          s = trim(s);
          i = int(split(s,','));
          if (i.length == 9){
          motor_a = i[1]; motor_b = i[2]; angle = i[3]; angle_offset = i[4]; kp = i[5]; ki = i[6]; kd = i[7];
          port.clear();
          }
          //
          s = "";
          }
        else{
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