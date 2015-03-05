/*=======================

  Bouncing bubbles
  
  @author: Toofifty
  
  =====================*/

// CUSTOM VALUES

public int num_bubbles = 15;            // number of bubbles to generate
public float spring = 0.05;             // bounciness
public float gravity = 0.03;            // acceleration due to gravity
public float friction = 0.01;           // de-acceleration when colliding
public boolean lights = true;           // 3D or 2D looking balls
public color[] palette = new color[] {  // possible bubble colours
  color(111, 144, 162),                 // any order, any amount
  color(71, 113, 135),
  color(17, 59, 81),
  color(3, 36, 54),
};

// VARIABLES
private Bubble[] bubbles = new Bubble[num_bubbles];

/** Setup sketch*/
void setup () {
  size(1280, 720, P3D);
  ortho();
  noStroke();
  
  // create bubbles
  for (int i = 0; i < num_bubbles; i++) {
    bubbles[i] = new Bubble(random(width), random(height), random(30, 150), i, bubbles);
  }
}

/** Draw frame */
void draw () {
  background(40, 84, 108); // refresh background
  if (lights) lights();    // make it look 3D with lights
  
  for (int i = 0; i < num_bubbles; i++) {
    bubbles[i].collide();        // check for collisions
    bubbles[i].move();           // move accordingly
    bubbles[i].draw();           // draw
  }
}

/** Bubble class */
class Bubble {
  // attributes
  private float x, y;
  private final float diameter;
  private float vx = 0;
  private float vy = 0;
  private final int id;
  private final color colour;
  private final Bubble[] others;
  
  /** Create bubble at <x, y> size <d> id <id> and other bubles <o> */
  Bubble (float x, float y, float d, int id, Bubble[] o) {
    this.x = x;
    this.y = y;
    this.diameter = d;                  
    this.id = id;       // numerical id
    this.others = o;    // all others able to be collided with
    this.colour = palette[
      int(random(0, palette.length))
    ]; // grab a random colour from the palette
  }
  
  /** Check with all 'others' whether a collision is happening */
  void collide () {
    for (int i = id + 1; i < num_bubbles; i++) {               // iterate all other bubbles
      float dx = others[i].x - this.x;                         // x difference
      float dy = others[i].y - this.y;                         // y difference
      float distance = dist(0, 0, dx, dy);                     // |difference|
      float minDist = others[i].diameter/2 + this.diameter/2;  // distance between centres
      
      if (distance < minDist) {                        // if touching
        float angle = atan2(dy, dx);                   // angle of collision
        float targetX = this.x + cos(angle) * minDist; // find resulting x velocity
        float targetY = this.y + sin(angle) * minDist; // find resulting y velocity
        float ax = (targetX - others[i].x) * spring;   // bounce in x direction
        float ay = (targetY - others[i].y) * spring;   // bounce in y direction
        this.vx -= ax;                                 // add velocity in x
        this.vy -= ay;                                 // add velocity in y
        others[i].vx += ax;                            // add velocity to other's x
        others[i].vy += ay;                            // add velocity to other's y
      }
    }
  }
  
  /** Move the bubble one step */
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
    
    this.vy += gravity;  // add gravity each frame
    this.x += vx;        // move by vx
    this.y += vy;        // move by vy
    
    if (this.x + diameter/2 > width) {    // if touching right wall
      this.x = width - diameter/2;        // do not go past wall
      this.vx *= friction;                // slow with friction
    } else if (this.x - diameter/2 < 0) { // if touching left wall
      this.x = diameter/2;                // ...
      this.vx *= friction;
    }
    
    if (this.y + diameter/2 > height) {   // if touching ceiling
      this.y = height - diameter/2;
      this.vy *= friction;
    } else if (this.y - diameter/2 < 0) { // if touching ground
      this.y = diameter/2;
      this.vy *= friction;
    }
  }
  
  /** Draw bubble */
  void draw () {
    translate(this.x, this.y);   // move to position
    fill(colour);                // fill with bubble colour
    sphere(diameter/2);          // draw
    translate(-this.x, -this.y); // move back
  }
}
