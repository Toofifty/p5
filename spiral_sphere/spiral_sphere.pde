/*------------------------------------------
  "Spiral Sphere"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

public color bg = color(255, 255, 255, 255);
public color fg = color(32, 32, 32, 255);
public float aw = 4; // arc width
public float max_r = 200;
public int num_arcs = 15;

Arc[] arcarray = new Arc[num_arcs];

void setup () {
  size(500, 500, P3D);
  ortho();
  noFill();
  frameRate(60);
  smooth(8);
  strokeWeight(aw);
  strokeCap(ROUND);
  stroke(fg);
  
  createArcs();
  
}

void draw () {
  lights();
  background(bg);
  translate(width/2, height/2, 0);
  rotateY(-PI/3);
  for (int i = 0; i < num_arcs; i++) {
    arcarray[i].draw();
    arcarray[i].setf((sin((frameCount+float(i)*10) / 60) + 1)/2 - 0.1);
  }
}

void createArcs () {
  for (int i = 0; i < num_arcs; i++) {
    int a = i - num_arcs / 2;
    float radius = sqrt(pow(max_r, 2) - pow(max_r/num_arcs * a * 2 + 1, 2));
    arcarray[i] = new Arc(max_r/num_arcs * a*2 + 1, radius);
    arcarray[i].setf(float(i)/num_arcs);
  }
}

class Arc {
  float z, r, f; // z-depth, radius, fill (% of 1)
  
  public Arc (float z, float r) {
    this.z = z;
    this.r = r;
    this.f = 0;
  }
  
  public void setf (float f) {
    this.f = constrain(f, 0, 1);
  }
  
  public void draw () {
    translate(0, 0, -z);
    fill(0, 0, 0, 10);
    arc(0, 0, r*2, r*2, f * -PI + float(frameCount)/60, f * PI + float(frameCount)/60);
    translate(0, 0, z);
  }
  
}