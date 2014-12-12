/*
  Appendix C: Main ROBOTC source code
  Main ROBOTC code
  By Neil, Rowan, Taran, Jake
  The following source code opens a file containing the names of all printable 
  files on the NXT brick, allows the user to choose a file to print, then opens
  that file and reads through it two integers at a time. If the two integers
  are both -1, then the code will cause the machine to raise the pen and if
  not, the code will read the integers as coordinates and cause the machine to
  move from the past set of coordinates to the ones being read.
*/

int x_max = 2200;
int y_max = 3500;
string textFile;

void raisePen() { 
  if (SensorValue[S1]) { //if pen is down
    motor[motorA] = 0;
    motor[motorB] = 0;
    wait1Msec(100);
    
    motor[motorC] = 30;
    while (SensorValue[S1]);
    wait1Msec(50);
    
    motor[motorC] = 0;
  }
}

void lowerPen() { 
  if (!SensorValue[S1]) { // if pen is raised
    motor[motorA] = 0;
    motor[motorB] = 0;
    wait1Msec(100);
    
    motor[motorC] = -30;
    while (!SensorValue[S1]);
    
    motor[motorC] = 0;
  }
}

void move_to(float x, float y) { 
  x = (x*x_max/850);
  y = (y*y_max/1100);

  float vx, vy;

  float dx = x - nMotorEncoder[motorA];
  float dy = y - nMotorEncoder[motorB];
  float distance = sqrt(dx*dx+dy*dy);

  do {
    // The y-axis motor carries more load,
    // so it is set to a higher relative value
    vx = 75*dx/distance;
    vy = 100*dy/distance;

    if (vx <10 || vy < 10){
      vx *= 4;
      vy *= 4;
    }
 
    else if (vx < 20 || vy < 20){
      vx *= 2;
      vy *= 2;
    }

    motor[motorA] = (int) vx;
    motor[motorB] = (int) vy;

    dx = x - nMotorEncoder[motorA];
    dy = y - nMotorEncoder[motorB];
    distance = sqrt(dx*dx+dy*dy);

  } while (abs(dx) > 2 || abs(dy) > 2);
  motor[motorA] = 0;
  motor[motorB] = 0;
}

void setTextFile() { 
  // FILE IO vars (From ROBOTC API DOCS)
  TFileHandle fileHandle;
  TFileIOResult IOResult;
  string file = "printables.txt";
  short fileSize = 0;

  OpenRead(fileHandle, IOResult, file, fileSize);

  char files[8][25];
  int fileNameLength[8];

  for (int i = 0; i < 8; i++)
    fileNameLength[i] = -1;

  char incomingChar;
  int nameCounter = 0;
  int letterCounter = 0;
  for (int i = 0; i < fileSize; i++){
    ReadByte(fileHandle, IOResult, incomingChar);

    if (incomingChar != (char)13 && incomingChar != (char)10) {

      files[nameCounter][letterCounter] = incomingChar;

      if (letterCounter >= 3){
        if (files[nameCounter][letterCounter-3] == '.' &&
            files[nameCounter][letterCounter-2] == 't' &&
            files[nameCounter][letterCounter-1] == 'x' &&
            files[nameCounter][letterCounter]   == 't') {
          fileNameLength[nameCounter] = letterCounter;
          letterCounter = -1;
          nameCounter++;
        }
      }
      letterCounter++;
    }
  }

  string string_files[8];
  for (int x = 0; x < 8; x++) {
    string_files[x] = "";
    for (int y = 0; y < fileNameLength[x] + 1; y++) {
      string_files[x] = string_files[x] + files[x][y];
    }
  }

  int beingDisplayed = 0;
  nxtDisplayCenteredTextLine(1, string_files[beingDisplayed]);
  while (nNxtButtonPressed != 3) {
    if (nNxtButtonPressed == 1) {
      beingDisplayed += nameCounter-1;
      beingDisplayed %= nameCounter;
      eraseDisplay();
      nxtDisplayCenteredTextLine(1, string_files[beingDisplayed]);
      while (nNxtButtonPressed != 1);
    } else if (nNxtButtonPressed == 2){
      beingDisplayed += 1;
      beingDisplayed %= nameCounter;
      eraseDisplay();
      nxtDisplayCenteredTextLine(1, string_files[beingDisplayed]);
      while (nNxtButtonPressed != -1);
    }
  }
  while (nNxtButtonPressed != -1);
  
  nxtDisplayCenteredBigTextLine(4, "Print?");
  while (nNxtButtonPressed != 3);

  textFile = string_files[beingDisplayed];

  Close(fileHandle,IOResult);
  
  wait1Msec(200);
}

void resetX() { 
  raisePen();
  motor[motorA] = -100;
  while (!SensorValue[S2]);
  
  motor[motorA] = 0;
  nMotorEncoder[motorA] = 0;
}

void startNewPage() {
  eraseDisplay();
  nxtDisplayString(5, "replace paper");
  nxtDisplayString(6, "press orange button");
  nxtDisplayString(7, "to continue");
  
  while (nNxtButtonPressed == -1);
  while (nNxtButtonPressed != -1);
  
  resetX();
  move_to(0,0);
  
  motor[motorC] = 30;
  wait1Msec(200);
  motor[motorC] = 0;
}

task main() {
  nMotorEncoder[motorA] = 0;
  nMotorEncoder[motorB] = 0;
  nMotorEncoder[motorC] = 0;
  // The touch sensor on the z-axis. True when the pen is touching the paper
  SensorType[S1] = sensorTouch;
  // The touch sensor on the x-axis. True when the x-axis is at the left.
  SensorType[S2] = sensorTouch;

  byte Nul = 0x00;

  setTextFile();  //choose textFile to print
  time1[T1] = 0;

  // Variable declarations
  int x = 0, y = 0, x_prev = 0, counter = 0;
  char x_string[4], y_string[4];

  // FILE IO vars (From ROBOTC API DOCS)
  TFileHandle     hFileHandle;
  TFileIOResult   nIOResult;
  short           fileSize = 0;
  char            incomingChar;

  OpenRead(hFileHandle, nIOResult, textFile, fileSize);

  int i = 0; // The position in the file
  while (i < fileSize) {
    x = 0;
    y = 0;

    // Read in x
    counter = 0;
    while (incomingChar!=' ') {
      ReadByte(hFileHandle, nIOResult, incomingChar);
      i++;
      if (incomingChar != ' '){
        x_string[counter] = incomingChar;
        counter++;
      }
    }
    incomingChar = Nul;

    for (int j = 0; j < counter; j++) {
      x += (x_string[j] - '0') * ceil(pow(10, counter - j - 1));
    }

    // Read in y
    counter = 0;
    while (incomingChar != ' ') {
      ReadByte(hFileHandle, nIOResult, incomingChar);
      i++;
      if (incomingChar != ' ') {
        y_string[counter] = incomingChar;
        counter++;
      }
    }

    incomingChar = Nul;
    for (int j = 0; j < counter; j++) {
      y += (y_string[j] - '0') * ceil(pow(10, counter - j - 1));
    }

    if (x_string[0] == '-' && y_string[0] == '-') {
      // -1 -1 was read in
      raisePen();
    } else {
      if (x_prev - x > 300){ //if the pen is going back to the left
        resetX();
      }
      
      move_to(x,y);
      x_prev = x;
      
      if(nMotorEncoder[motorB] > y_max){
        startNewPage();
        return;
      }
      lowerPen();
    }
  }
  
  Close(hFileHandle, nIOResult);

  eraseDisplay();
  nxtDisplayString(0,"Time Passed:");
  nxtDisplayString(1,"%.2f s",time1[T1]/1000.0);
  while(nNxtButtonPressed!=-1);
  while(nNxtButtonPressed==-1);
}
