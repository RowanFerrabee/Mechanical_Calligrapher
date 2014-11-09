import processing.serial.*;

Serial serial;
byte[] len;
byte[] command;
int val = 0;

void setup(){
  println(Serial.list()); 
  size(600,400);
  background(0);
  serial = new Serial(this, Serial.list()[1], 9600);
  serial.write(0xFF);
  len = new byte[2];
  command = new byte[2];
  command[0] = (byte) 0x01;
  command[1] = (byte) 0x88;
//  command = new byte[6];
//  command[0] = (byte) 0x80;
//  command[1] = (byte)0x09;
//  command[2] = (byte)0x00;
//  command[3] = (byte)0x02;
//  command[4] = (byte)'a';
//  command[5] = (byte)'\0';
//  len[0] = (byte)command.length;
//  serial.write(len[0]);
//  serial.write(len[1]);
//  for (int i = 0; i < 2; i++) {
//    serial.write(command[i]);
//  }
serial.write(50);
  val = serial.read();
  // For debugging
  println( "Raw Input:" + val);
}

void draw(){
  serial.write(50);
  if (serial.available() > 0) {
    val = serial.read();
    println( "Raw Input:" + val);
  }
  serial.write(50);
}

void mousePressed(){
  serial.write(50);
}

//void serialEvent(Serial port) {
//  // Data from the Serial port is read in serialEvent() using the read() function and assigned to the global variable: val
//  val = port.read();
//  // For debugging
//  println( "Raw Input:" + val);
//}
