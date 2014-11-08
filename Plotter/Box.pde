class Box{

    int x;
    int y;
    int w;
    int h;
  
    Box(int a, int b, int c, int d){x=a;y=b;w=c;h=d;}
    
    void drawLetter(int num, int[] coordinates){
        noStroke();
        fill(255,255,255);
        rect(x,y,w,h);
        strokeWeight((h/40)+1);
        stroke(0,0,0);
        fill(0,0,0);

        int tempX = 0,tempY = 0;
        if(num>0){
        tempX = x + w*coordinates[0]/170;
        tempY = y + h*coordinates[1]/300;}
        
        for (int i=2; i<num; i+=2) {
          if (coordinates[i]==-1 && coordinates[i+1]==-1) {
            tempX = x+w*coordinates[i+2]/170;
            tempY = y+h*coordinates[i+3]/300;
            i+=2;
          } else {
            line(tempX, tempY, x+w*coordinates[i]/170, y+h*coordinates[i+1]/300);
            tempX = x+w*coordinates[i]/170;
            tempY = y+h*coordinates[i+1]/300;
          }
        }
    }
};
