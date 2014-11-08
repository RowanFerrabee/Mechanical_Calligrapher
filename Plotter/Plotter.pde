import controlP5.*;
 
ControlP5 cp5;
ControlFont cf1;
 
 
int hor_indent = 1;
int vert_indent = 1;
int box_size_x = 17*2/3;
int box_size_y = 30*2/3;
boolean check = true; 
int i=0,j=0;
String name;
String textFile;
String[] handwriting;
String[] text;
HashMap<String, IntList> letters;

void setup() {
  size(850*7/12, 1100*7/12);
  background(0);
  
  textSize(60);
  cf1 = new ControlFont(createFont("Arial",20));
  cp5 = new ControlP5(this);
  cp5.addTextfield("Username").setPosition(30/2, height/3/2).setSize((width*3/4-30)/2, (width/4-60)/2).setAutoClear(false);
  cp5.addBang("Submit").setPosition((width*3/4+30)/2, height/3/2).setSize((width/4-60)/2, (width/4-60)/2);
  
  letters = new HashMap<String, IntList>();
}
  
void draw () {}
 
void Submit() {
  name = cp5.get(Textfield.class,"Username").getText();
  cp5.remove("Username");
  cp5.remove("Submit");
  background(0);
  cp5.addTextfield("Text File").setPosition(30/2, height/3/2).setSize((width*3/4-30)/2, (width/4-60)/2).setAutoClear(false);
  cp5.addBang("Plot").setPosition((width*3/4+30)/2, height/3/2).setSize((width/4-60)/2, (width/4-60)/2);
}

void Plot() {
  textFile = cp5.get(Textfield.class,"Text File").getText();
  cp5.remove("Text File");
  cp5.remove("Plot");
  println("Nume: "+name+", File: " + textFile);
  handwriting = loadStrings(name+".txt");
  text = loadStrings(textFile);
  background(255);
  setHashTable();
  Box b;
  for (int i=0; i<text.length; i++) {
    for (int j=0; j<text[i].length(); j++) {
      if (letters.containsKey(Character.toString(text[i].charAt(j)))) {
        if(text[i].charAt(j)!=' '||hor_indent!=0){
          b = new Box(hor_indent*box_size_x,vert_indent*box_size_y,box_size_x,box_size_y);
          b.drawLetter(letters.get(Character.toString(text[i].charAt(j))).size(),letters.get(Character.toString(text[i].charAt(j))).array());
        }
      }
      hor_indent+=1;
      if((hor_indent+3)*box_size_x>width&&(text[i].charAt(j+1)!=' ')){
        b = new Box(hor_indent*box_size_x,vert_indent*box_size_y,box_size_x,box_size_y);
        b.drawLetter(letters.get("-").size(),letters.get("-").array());
        hor_indent = 1;
        vert_indent += 1;
      }
    }
    vert_indent+=1;
    hor_indent = 1;
  }
}

void setHashTable(){
  IntList space = new IntList();
  letters.put(" ",space);
  for(int i=0; i<handwriting.length; i+=2){
    String s = handwriting[i];
    String[] coordinates = splitTokens(handwriting[i+1]," ");
    IntList lines = new IntList();
    for(int j=2; j<coordinates.length; j++)
      lines.append(Integer.parseInt(coordinates[j]));
    letters.put(s,lines);
  }
}
