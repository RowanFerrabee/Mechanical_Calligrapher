import processing.serial.*;

Serial serial;

void setup(){
  println(Serial.list()); 
  serial = new Serial(this, Serial.list()[1], 9600);
}

void draw(){}

void mousePressed(){
  serial.write(0xFF);
}
