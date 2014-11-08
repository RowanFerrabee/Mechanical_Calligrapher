import controlP5.*;

ControlP5 cp5;

IntList arr;
int tempX;
int tempY;
boolean newLine = true;
int n = 0;
boolean check = false;
String name;
String upDown;
PrintWriter output;
int minus_ones = 0;

PFont font;

void setup(){
  
  size(170,300);
  background(0);
  
  font = createFont("arial",12);
  textFont(font, 12);
  
  cp5 = new ControlP5(this);
  cp5.addTextfield("Username").setPosition(17, height/3).setSize(100, 30).setAutoClear(false);
  cp5.addBang("Submit").setPosition(127, height/3).setSize(30, 30);
  
  arr = new IntList();
  keyCode = UP;
  frame.setResizable(true);
}

void draw(){
  if(!check){
    
  } else {
    if(keyCode==DOWN){
      upDown = "Down";
      if(mousePressed){
        line(tempX,tempY,mouseX,mouseY);
        tempX=mouseX;
        tempY=mouseY;
        arr.append(mouseX);
        arr.append(mouseY);
        mousePressed=false;
        newLine=false;
      }
    } else {
      upDown = "Up";
    }
    pushStyle();
      noStroke();
      fill(255,255,255);
      rect(0,0,width,20);
      fill(0,0,0);
      textAlign(TOP,CENTER);
      text("Pen "+upDown,6,10);
      if(mouseX>width-40&&mouseX<width-5&&mouseY>4&&mouseY<25){
        fill(255,0,0);
        if(mousePressed){
          output.flush();
          output.close();
          exit();
        }
      }
      text("Done",width-38,11);
    popStyle();
    if(newLine){
      tempX=mouseX;
      tempY=mouseY;
    }
  }
}



void keyPressed(){

  if (check) {
    if (keyCode == UP) {
      arr.append(-1);
      arr.append(-1);
      minus_ones+=2;
    } else if (keyCode == DOWN) { 
      newLine = true;
    } else if (keyCode != SHIFT){
      char letter = key;
      
      output.println(letter);
      output.print(arr.size()+" ");
      
      int num = arr.size()-minus_ones;
      output.print(num+" ");
      for(int i=0; i<arr.size(); i++){
        output.print(arr.get(i)+" ");
      }
      output.println();
      
      drawTemplate();
      arr.clear();
      minus_ones = 0;
      newLine = true;
      keyPressed = false;
    }
  }
  
}

void drawTemplate(){
  if (check) {
    background(255,255,255);
    pushStyle();
      stroke(50,50,255,80);
      line(0, height/8, width, height/8);
      line(0, height/2, width, height/2);
      line(0, 7*height/8, width, 7*height/8);
      stroke(50,50,255,60);
      pushMatrix();
        translate(width/24,0);
        for(int i=0; i<12; i+=2){
          line(i*width/12,(height/2+height/8)/2,(i+1)*width/12,(height/2+height/8)/2);
          line(i*width/12,(height/2+7*height/8)/2,(i+1)*width/12,(height/2+7*height/8)/2);
        }
      popMatrix();    
    popStyle();
  } else {
    background(0);
  }
}

void Submit() {
  name = cp5.get(Textfield.class,"Username").getText();
  cp5.remove("Username");
  cp5.remove("Submit");
  check = true;
  drawTemplate();
  output = createWriter(name+".txt");
}
