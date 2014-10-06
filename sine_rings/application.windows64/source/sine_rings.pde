/*------------------------------------------
  "Sine Rings"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

public int num_rings = 17;                        // number of rings
public int ring_th = 10;                          // ring thickness
public int gap = 5;                               // gap between rings
public int size = 500;                            // animation size
public int fps = 60;                              // fps
public float m_str = 100;                         // max stretch
public float base_rotation = PI/4;                // rotation applied each frame
public float[] fg = new float[]{32, 32, 32};      // foreground colour
public float[] bg = new float[]{255, 255, 255};   // background colour
public boolean record = false;                    // save frames to many many .pngs

private float stretch = 0;                        // difference between rings
private float t = 0;                              // clock
private Ring[] rings = new Ring[num_rings];       // ring array

// Processing setup call
void setup () {
  size(size, size);      // Graphics Setup //
  frameRate(fps);        // framerate
  smooth(8);             // smooth edges
  noStroke();            // no stroke
  
                         // create rings
  for (int n = 0; n < num_rings; n++) rings[n] = new Ring(2 * n * (ring_th + gap));
}

// Processing draw call
void draw () { 
  background(bg[0], bg[1], bg[2]);    // fill background
  translate(height / 2, width / 2);   // move to centre
  rotate(base_rotation);              // rotate by base angle
  
  for (int n = num_rings-1; n >= 0; n--) {
    rings[n].draw();                                                        // draw all rings (backwards, so smaller are drawn over larger)
    rings[n].set_c(0.25 * sin(PI * (t + n * stretch) / 10 / fps) + 0.25);   // change ring size with t, n, and stretch
  }
  t++;                                                                      // increment clock
  stretch = m_str * sin(PI * t / 10 / fps);                                 // update stretch with t
  if (t < fps * 10 && record) saveFrame("rings_" + nf((int)t, 3) + ".png"); // record if we want
}

class Ring {
  float c, r;                                       // circumference %, radius
  Ring (float r) { this.r = r; }                    // create ring with radius
  void set_c (float p) { c = constrain(p, 0, 1); }  // set circumference, constrain from 0 - 1 (just in case)
  
  void draw () {
    fill(fg[0], fg[1], fg[2]);                                                  // fill foreground colour
    arc(0, 0, r, r, -2 * PI * c, 2 * PI * c, PIE);                              // draw pie from -angle to +angle
    fill(bg[0], bg[1], bg[2]);                                                  // fill background colour
    arc(0, 0, r - ring_th, r - ring_th, -2 * PI * c - 1, 2 * PI * c + 1, PIE);  // 'erase' most of pie, to make a ring
  }
}
