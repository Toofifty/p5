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

public class inverse_squares extends PApplet {

/*------------------------------------------
  "Inverse squares"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

// "Play with me!" variables.

public int num_squares = 13;                     // odds work best
public int fps = 60;                             // fps
public int size = 400;                           // screen size
public float rotate_time = 10;                   // seconds
public float[] c1 = new float[]{4, 29, 55};      // default navy-blue-ish
public float[] c2 = new float[]{255, 255, 255};  // default white
public boolean flip = true;                      // flip direction after each phase
public boolean record = false;                   // output to many, many png files

// "Don't touch!" variables.

private Square[] sqs;   // square array
private float sq_d;     // diameter
private float sq_r;     // radius
private int phase = 0;  // phase (0|1)
private int t = 0;      // clock

// Processing setup call
public void setup () {
                                                           // Graphics Setup //
  size(size + size/num_squares, size + size/num_squares);  // make the size a little larger for spinning squares
  background(c1[0], c1[1], c1[2]);                         // set background to c1 to start
  frameRate(fps);                                          // set framerate
  noStroke();                                              // remove black strokes
  
                                                           // Inital Variable Setup //
  sqs = new Square[num_squares*num_squares];               // create squares array
  sq_d = size / num_squares;                               // grab diameter
  sq_r = sq_d / 2;                                         // grab radius
  
  int n = 0;                                               // Fill Squares Array //
  for (int j = 0; j < num_squares; j++) {
    for (int i = 0; i < num_squares; i++) {
      sqs[j*num_squares+i] = new Square(i, j, n % 2 == 0); // coordinates in multiples of sq_d, as multiplied by
      n++;                                                 // in the Square class. 
    }                                                      // alternates between c1 and c2 squares.
  }
}

// Processing draw call
public void draw () {
  background(c2[0], c2[1], c2[2]);                           // c2 background always present
  translate(size / num_squares / 2, size / num_squares / 2); // allow for whitespace on the sides
  if (phase == 0) {
    fill(c1[0], c1[1], c1[2]);                               // create a psuedo c1 background when in the first
    rect(0, 0, num_squares * sq_d, num_squares * sq_d);      // phase.
  }
  
  for (int n = 0; n < num_squares*num_squares; n++) {
    if (sqs[n] == null) continue;
    if (sqs[n].f != phase) {                      // if not in phase, ensure square clock is zero
      if (sqs[n].t != 0) {
        sqs[n].clear();
      }                                           // do not draw square if out of phase
      continue;                                   // (wont be visible, background will be same colour)
    }
    sqs[n].update();                              // apply update to square rotation
    sqs[n].draw();                                // call square's draw
  }
  t++;                                            // increment clock
  
  if (record) {
    saveFrame("sq_" + nf(t,3) + ".png");          // save frame if recording and not finished
  }
  if (t % (fps * rotate_time / 4) == 0) {         // change phase every quarter turn
    phase = phase == 1 ? 0 : 1;                   // swap phase (could've used bool but meh)
    if (t % (fps * rotate_time / 2) == 0) {
      t = 0;                                      // stop recording after a full iteration
      record = false;
    }
  }
}

class Square {
  float x;    // centre
  float y;    // centre
  float[] c;  // colour
  float r;    // rotation
  float t;    // rotation clock
  int f;      // phase group
  
  // Create square
  Square (float _x, float _y, boolean _f) {
    this.x = _x*sq_d + sq_r;
    this.y = _y*sq_d + sq_r;
    this.f = _f ? 1 : 0;
    this.r = 0;
    this.t = 0;
    this.c = _f ? c1 : c2;
  }
  
  // Update rotation value
  public void update () {
    float dr = sin(4*t*PI/(fps * rotate_time))/fps; // sin speeds up and slows down just perfect
    
    if (flip && f == 1) { // go in opposite direction if flip is enabled
      r -= dr;
      r = max(r, -PI/2);
      r = min(r, 0);
    } else {
      r += dr;            // apply regular rotation
      r = min(r, PI/2);   // wouldn't be needed but doesn't stop exactly on PI/4
      r = max(r, 0);      // shouldn't go far backwards either
    }
    t++;
  }
  
  public void clear () {
    t = 0;
    r = 0;
  }
  
  public void draw () {
    translate(this.x, this.y);              // go to point to apply rotation around square centre
    rotate(r);                              // rotate by pre calculated r
    fill(this.c[0], this.c[1], this.c[2]);  // set fill colour
    rect(-sq_r, -sq_r, sq_d, sq_d);         // draw square centred around current point
    rotate(-r);                             // rotate back
    translate(-this.x, -this.y);            // move back
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "inverse_squares" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
