import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class bouncing_bubbles extends PApplet {

/*------------------------------------------
  "Bouncing Bubbles"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

// "Play with me!" variables.

public int num_bubbles = 15;            // number of bubbles to generate
public float spring = 0.05f;             // bounciness
public float gravity = 0.03f;            // acceleration due to gravity
public float friction = 0.01f;           // de-acceleration when colliding
public boolean lights = true;           // 3D or 2D looking balls
public int[][] palette = new int[][] {  // possible bubble colours
  { 111, 144, 162 },
  { 71, 113, 135 },
  { 17, 59, 81 },
  { 3, 36, 54 },
};

// "Don't touch!" variables.

private Bubble[] bubbles = new Bubble[num_bubbles];

// Processing setup call
public void setup () {
                           // Graphics Setup //
  size(1080, 720, P3D);    // size + init 3D
  ortho();                 // not perspective
  noStroke();              // no wireframes on balls
  
  for (int i = 0; i < num_bubbles; i++) {
    bubbles[i] = new Bubble(random(width), random(height), random(30, 150), i, bubbles); // create bubbles at random places
  }
}

// Processing draw call
public void draw () {
  background(40, 84, 108); // refresh background
  if (lights) lights();    // make it look 3D with lights
  
  for (int i = 0; i < num_bubbles; i++) {
    bubbles[i].collide();        // check for collisions
    bubbles[i].move();           // move accordingly
    bubbles[i].draw();           // draw
  }
}

class Bubble {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  int[] colour = new int[3];
  Bubble[] others;
  
  Bubble (float x, float y, float d, int id, Bubble[] o) {
    this.x = x;
    this.y = y;
    this.diameter = d;                  
    this.id = id;                             // numerical id
    this.others = o;                          // all others able to be collided with
    this.colour = palette[PApplet.parseInt(random(0, 3))]; // grab a random colour from the palette
  }
  
  public void collide () {
    for (int i = id + 1; i < num_bubbles; i++) {               // iterate through every other bubble
      float dx = others[i].x - this.x;                         // find x difference
      float dy = others[i].y - this.y;                         // find y difference
      float distance = sqrt(dx*dx + dy*dy);                    // find mag difference
      float minDist = others[i].diameter/2 + this.diameter/2;  // find distance where the bubbles should collide
      
      if (distance < minDist) {                                // if closer (touching)
        float angle = atan2(dy, dx);                           // find angle of collision
        float targetX = this.x + cos(angle) * minDist;         // find resulting x velocity
        float targetY = this.y + sin(angle) * minDist;         // find resulting y velocity
        float ax = (targetX - others[i].x) * spring;           // bounce in x direction depending on spring
        float ay = (targetY - others[i].y) * spring;           // bounce in y direction depending on spring
        this.vx -= ax;                                         // add velocity in x
        this.vy -= ay;                                         // add velocity in y
        others[i].vx += ax;                                    // add velocity to other x
        others[i].vy += ay;                                    // add velocity to other y
      }
    }
  }
  
  public void move () {
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
  
  public void draw () {
    translate(this.x, this.y);                                  // move to position
    fill(this.colour[0], this.colour[1], this.colour[2], 200);  // fill with bubble colour
    sphere(diameter/2);                                         // draw
    translate(-this.x, -this.y);                                // move back
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "bouncing_bubbles" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
