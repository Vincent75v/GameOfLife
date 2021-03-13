import de.bezier.guido.*;
public final static int NUM_ROWS = 70;
public final static int NUM_COLS = 70;
private Life[][] buttons; //2d array of Life buttons each representing one cell
private boolean[][] buffer; //2d array of booleans to store state of buttons array
private boolean running = true; //used to start and stop program

public void setup () {
  size(700, 700);
  frameRate(9);
  // make the manager
  Interactive.make( this );
  buttons = new Life [NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++)
  {
    for (int j = 0; j < NUM_COLS; j++)
    {
      buttons[i][j] = new Life(i, j);
    }
  }
  buffer = new boolean[NUM_ROWS][NUM_COLS];
}
public void draw () {
  background( 0 );
  if (running == false) //pause the program
    return;
  copyFromButtonsToBuffer();
  for (int i = 0; i < NUM_ROWS; i++)
  {
    for (int j = 0; j < NUM_COLS; j++)
    {
      if (countNeighbors(i, j) == 3)
        buffer[i][j] = true;
      else if (countNeighbors(i, j) == 2 && buttons[i][j].getLife())
        buffer[i][j] = true;
      else
        buffer[i][j] = false;
      buttons[i][j].draw();
    }
  }
  copyFromBufferToButtons();
}

public void keyPressed() {
  if (key == ' ') running = !running;
}
public void copyFromBufferToButtons() {
  for (int i = 0; i< NUM_ROWS; i++)
  {
    for (int j = 0; j < NUM_COLS; j++)
    {
      buttons[i][j].setLife(buffer[i][j]);
    }
  }
}

public void copyFromButtonsToBuffer() {
  for (int i = 0; i< NUM_ROWS; i++)
  {
    for (int j = 0; j < NUM_COLS; j++)
    {
      buffer[i][j] = buttons[i][j].getLife();
    }
  }
}

public boolean isValid(int r, int c) {
  if (r<NUM_ROWS && c<NUM_COLS && r >= 0 && c >= 0) return true;
  else return false;
}

public int countNeighbors(int row, int col) {
  int count = 0;
  for (int r = row-1; r<=row+1; r++)
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c) && buttons[r][c].getLife()==true)
        count++;
  if (buttons[row][col].getLife()==true)
    count--;
  return count;
}
public class Life {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean alive;

  public Life (int row, int col) {
    width = 700/NUM_COLS;
    height = 700/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    alive = Math.random() < .5; // 50/50 chance cell will be alive
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    alive = !alive; //turn cell on and off with mouse press
  }
  public void draw () {    
    if (alive != true)
      fill(0);
    else 
    fill( 150 );
    rect(x, y, width, height);
  }
  public boolean getLife() {
    return alive;
  }
  public void setLife(boolean living) {
    alive = living;
  }
}
