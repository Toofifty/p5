/*------------------------------------------
  "Inverse squares"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

// Custom variables

public final int NUM_SQUARES = 7; // odds work best
public final int SIZE = 300;
public final float ROTATE_TIME = 10; // seconds
public final color COLOUR1 = color(32);
public final color COLOUR2 = color(255);
public final boolean FLIP = true;    // flip direction after each phase
public boolean record = false; // output to many png files

private Square[] sqs;
private float sq_d; // diameter
private float sq_r; // radius
private boolean phase;
private int t;      // clock

void setup() {
  
  size(SIZE + SIZE/NUM_SQUARES, SIZE + SIZE/NUM_SQUARES);
  noStroke();
  smooth(8);
  
  background(COLOUR1);
  
  sqs = new Square[NUM_SQUARES * NUM_SQUARES];
  sq_d = SIZE / NUM_SQUARES;
  sq_r = sq_d / 2;
  
  boolean col = false; 
  
  for (int j = 0; j < NUM_SQUARES; j++) {
    
    for (int i = 0; i < NUM_SQUARES; i++) {
      
      sqs[j * NUM_SQUARES + i] = new Square(i, j, col);
      col = !col;
      
    }
    
  }
  
}

void draw() {
  
  background(COLOUR1);
  
  translate(SIZE / NUM_SQUARES / 2, SIZE / NUM_SQUARES / 2);
  
  if (phase) {
    
    fill(COLOUR2);
    rect(0, 0, NUM_SQUARES * sq_d, NUM_SQUARES * sq_d);
    
  }
  
  for (Square s : sqs) {
    
    if (s.group != phase) {
      
      if (s.group) {
        
        s.reset();
        
      }
      
      continue;
      
    }
    
    s.update();
    s.draw();
    
  }
  
  t++;
  
  if (record) saveFrame("sq_" + nf(t,3) + ".png");
  
  if (t % (60 * ROTATE_TIME / 4) == 0) {
    
    phase = !phase;
    
    if (t % (60 * ROTATE_TIME / 2) == 0) {
      
      t = 0;
      record = false;
      
    }
    
  }
  
}

class Square {
  
  float x, y;
  color colour;
  float rotation, time;
  boolean group;
  
  Square(float x, float y, boolean g) {
    
    this.x = x * sq_d + sq_r;
    this.y = y * sq_d + sq_r;
    this.group = g;
    this.colour = g ? COLOUR1 : COLOUR2;
    
  }
  
  void update() {
    
    float dr = sin(4 * time * PI / (60 * ROTATE_TIME)) / 60;
    
    if (FLIP && group) {
      
      rotation -= dr;
      rotation = constrain(rotation, -HALF_PI, 0);
      
    } else {
      
      rotation += dr;
      rotation = constrain(rotation, 0, HALF_PI);
    }
    
    time++;
    
  }
  
  void reset() {
    
    rotation = 0;
    time = 0;
    
  }
  
  void draw() {
    
    translate(x, y);
    rotate(rotation);
    fill(colour);
    rect(-sq_r, -sq_r, sq_d, sq_d);
    rotate(-rotation);
    translate(-x, -y);
    
  }
  
}
