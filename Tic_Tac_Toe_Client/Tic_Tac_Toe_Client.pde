import processing.net.*;

Client myClient;
int[][] grid;
boolean myTurn;
color blue = #A1DBB2;
color red = #F45D4C;

void setup() {
  size (300, 400);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  myClient = new Client(this, "127.0.0.1", 1234);
  myTurn = false;
}

void draw() {
  if (myTurn) background(blue);
  else background(red);  
  stroke(255);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);

  int row=0;
  int col=0;
  while (row<3) {
    drawXO(row, col);
    col++;
    if (col==3) {
      col =0;
      row++;
    }
  }
  fill(255);
  text(mouseX+" "+ mouseY, 150, 350);

  if (myClient.available()>0) {
    String incoming = myClient.readString();
    int r = int(incoming.substring(0, 1));
    int c = int(incoming.substring(2, 3));
    grid[r][c] = 1;
    myTurn = true;
  }
}

void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid[row][col]==1) {
    fill(0, 0);
    ellipse(50, 50, 90, 90);
  } else if (grid[row][col]==2) {
    line(10, 10, 90, 90);
    line(90, 10, 10, 90);
  }
  popMatrix();
}


void mouseReleased() {
  int row = mouseX/100;
  int col = mouseY/100;
  if (grid[row][col]==0 && myTurn) {
    myClient.write(row + "," + col);
    grid[row][col]=2;
    myTurn = false;
  }
}
