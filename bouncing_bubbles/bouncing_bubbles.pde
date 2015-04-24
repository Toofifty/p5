/*=======================

  Bouncing bubbles
  
  @author: Toofifty
  
  =====================*/

// CUSTOM VALUES

public final int NUM_BUBBLES = 15;            // number of bubbles to generate
public final float SPR = 0.05;                // bounciness
public final float G = 0.03;                  // acceleration due to gravity
public final float FR = 0.01;                 // de-acceleration when colliding
public final boolean LIGHTS = false;          // 3D or 2D looking balls
public final color[] PALETTE = new color[] {  // possible bubble colours
  color(111, 144, 162),                       // any order, any amount
  color(71, 113, 135),
  color(17, 59, 81),
  color(3, 36, 54),
};

// VARIABLES
private Bubble[] bubbles = new Bubble[NUM_BUBBLES];

void setup () {
  
  size(1280, 720, P3D);
  ortho();
  noStroke();
  
  for (int i = 0; i < NUM_BUBBLES; i++) {
    
    bubbles[i] = new Bubble(random(width), random(height), random(30, 150), i, bubbles);
    
  }
  
}

void draw () {
  
  background(40, 84, 108);
  
  if (LIGHTS) lights();
  
  for (int i = 0; i < NUM_BUBBLES; i++) {
    
    bubbles[i].collide();
    bubbles[i].move();
    bubbles[i].draw();
    
  }
}

class Bubble {
  
  private float x, y;
  private float vx, vy;
  private final int id;
  private final color colour;
  private final float diameter;
  private final Bubble[] others;
  
  Bubble (float x, float y, float d, int id, Bubble[] o) {
    
    this.x = x;
    this.y = y;
    this.diameter = d;                  
    this.id = id;
    this.others = o;
    this.colour = PALETTE[int(random(0, PALETTE.length))];
   
  }
  
  void collide () {
    
    for (int i = id + 1; i < NUM_BUBBLES; i++) {               // iterate all other bubbles
      
      float dx = others[i].x - this.x;                         // x difference
      float dy = others[i].y - this.y;                         // y difference
      float distance = dist(0, 0, dx, dy);                     // |difference|
      float minDist = others[i].diameter/2 + this.diameter/2;  // distance between centres
      
      if (distance < minDist) {                        // if touching
        
        float angle = atan2(dy, dx);                   // angle of collision
        float targetX = this.x + cos(angle) * minDist; // find resulting x velocity
        float targetY = this.y + sin(angle) * minDist; // find resulting y velocity
        float ax = (targetX - others[i].x) * SPR;   // bounce in x direction
        float ay = (targetY - others[i].y) * SPR;   // bounce in y direction
        this.vx -= ax;                                 // add velocity in x
        this.vy -= ay;                                 // add velocity in y
        others[i].vx += ax;                            // add velocity to other's x
        others[i].vy += ay;                            // add velocity to other's y
        
      }
      
    }
    
  }
  
  void move () {
    
    if (mousePressed) {                           // mouse dragging
    
      float disX = mouseX - this.x;               // distance between mouse and x
      float disY = mouseY - this.y;               // distance between mouse and y
      float mDis = sqrt(disX*disX + disY*disY);   // magnitude of distance
      
      if (mDis < diameter/2) {                    // if mouse is within bubble
      
        this.x += mouseX - pmouseX;               // move x on mouse dx
        this.y += mouseY - pmouseY;               // move y on mouse dy
        this.vx = mouseX - pmouseX;               // add x velocity
        this.vy = mouseY - pmouseY;               // add y velocity
        return;                                   // do not move normally while held
        
        
      }
      
    }
    
    this.vy += G;
    this.x += vx;
    this.y += vy;
    
    if (this.x + diameter/2 > width) {    // right wall
    
      this.x = width - diameter/2;        // do not go past wall
      this.vx *= FR;                      // slow with friction
      
    } else if (this.x - diameter/2 < 0) { // left wall
    
      this.x = diameter/2;
      this.vx *= FR;
      
    }
    
    if (this.y + diameter/2 > height) {   // ceiling
    
      this.y = height - diameter/2;
      this.vy *= FR;
      
    } else if (this.y - diameter/2 < 0) { // ground
    
      this.y = diameter/2;
      this.vy *= FR;
      
    }
    
  }
  
  void draw () {
    translate(this.x, this.y);
    fill(colour);
    sphere(diameter/2);
    translate(-this.x, -this.y);
  }
}
