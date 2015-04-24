/*------------------------------------------
  "Hexa Cubes"
  By Alex Matheson
    toofifty.me | ello.co/matho | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

// Custom variables
 
public final int NUM_CUBES = 10;
public final int SPREAD = 10;         // frames between new cubes rotating
public final int SCREEN_SIZE = 300;
public final float ROTATE_TIME = 120;
public final float SIZE_DIFF = 20;
public boolean record = false;        // output to many png files

private int t = 0; // clock
private Cube[] cubes = new Cube[NUM_CUBES];

void setup () {
  
  size(SCREEN_SIZE, SCREEN_SIZE, P3D);
  ortho();
  noFill();
  stroke(50);
  background(255);
  smooth(8);
  
  for (int i = 0; i < NUM_CUBES; i++) {
    
    // cube size increases by SIZE_DIFF each loop
    cubes[i] = new Cube(i * SIZE_DIFF);
    
  }
  
}

void draw () {
  
  background(255);
  translate(width/2, height/2, 0);
  
  // isometric angles
  rotateX(-0.6153187f);
  rotateY(PI/4);
  
  for (Cube c : cubes) {
    
    c.update();
    c.draw();
    
  }
  
  if (t % SPREAD == 0 && t/SPREAD < NUM_CUBES) {
 
    // begin next cube spinning every
    // SPREAD frames
    cubes[t/SPREAD].start();
    
  }
  
  if (record) saveFrame("hexa-"+(t+1)+".png");
  
  t++;
  if (t > ROTATE_TIME * 1.8) {
 
    // restart anim
    t = 0;
    record = false;

  }
}

class Cube {
  
  float size, angle;
  int t;
  boolean active = false;
 
  public Cube (float s) {
    
    this.size = s;
    
  }
  
  public void update () {
    
    if (active) {
      
      if (this.t >= ROTATE_TIME) {
      
        // reset cube
        active = false;
        this.t = 0; 
        return;
        
      }
      
      this.angle = -PI * (cos(this.t * PI / ROTATE_TIME) + 1) / 2;
      this.t++;
      
    }
    
  }
  
  public void start() {
    
    active = true;
    
  }
  
  public void draw () {
    
    rotateY(angle);
    box(size);
    rotateY(-angle);
    
  }
  
}
