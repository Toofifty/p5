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

public class hexa_cubes extends PApplet {

/*------------------------------------------
  "Hexa Cubes"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

// "Play with me!" variables.
 
public int t = 0;               // clock
public int num_cubes = 10;      // number of cubes
public int spread = 10;         // frames between new cubes rotating
public int fps = 60;            // fps
public int s_size = 300;        // screen size
public float time = 120;        // frames it takes to rotate
public float size = 20;         // size difference between cubes
public boolean record = false;  // output to many, many png files

// "Don't touch!" variables.

private Cube[] cubes = new Cube[num_cubes];  // cubes array

// Processing setup call
public void setup () {
                               // Graphics Setup //
  size(s_size, s_size, P3D);   // size
  ortho();                     // no perspective (needed to make hexagons)
  frameRate(fps);              // set framerate
  noFill();                    // don't colour cubes
  stroke(50);                  // stroke cubes
  background(255);             // white background
  
  for (int i = 0; i < num_cubes; i++) {
    cubes[i] = new Cube(i * size);       // create larger and larger cubes
  }
}

// Processing draw call
public void draw () {
  background(255);                 // clear screen
  translate(width/2, height/2, 0); // move to centre of animation
  rotateX(-0.6153187f);            // position isometrically
  rotateY(PI/4);
  
  for (int i = 0; i < num_cubes; i++) {
    cubes[i].update();                   // update rotation
    cubes[i].draw();                     // draw cubes
  }
  
  if (t % spread == 0 && t/spread < num_cubes) {  // offset rotation beginnings
    cubes[t/spread].s();                          // initiate rotation
  }
  
  if (record) saveFrame("hexa-"+(t+1)+".png");    // save frame if recording
  
  t++;                    // increment clock
  if (t > time * 1.8f) {   // restart animation after some time has passed
    t = 0;                // reset clock
    record = false;       // stop recording
  }
}

class Cube {
  float s;                 // cube size (in all dimensions)
  float a = 0;             // rotation angle
  int t = 0;               // cube clock
  boolean active = false;  // active switch
 
  // Create cube 
  public Cube (float s) {
    this.s = s;
  }
  
  // Update rotation value
  public void update () {
    if (active) {
      if (this.t >= time) {  // deactivate if finished
        active = false;      // turn off switch
        this.t = 0;          // reset clock 
        return;              // quit before changing angle again
      }
      this.a = -PI * (cos(this.t * PI / time) + 1) / 2;  // grab angle from cos graph
      this.t++;                                          // increment internal clock
    }
  }
  
  // Start rotation
  public void s () {
    active = true;
  }
  
  public void draw () {
    rotateY(this.a);   // rotate before drawing
    box(this.s);       // draw
    rotateY(-this.a);  // rotate back
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "hexa_cubes" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
