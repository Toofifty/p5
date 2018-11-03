/*------------------------------------------
  "Better Trixel Folder"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

float max_scale = 2;
float min_scale = 1;

float scale = max_scale;

boolean flip = false;

float BHLF_HEIGHT = 0.5 / sqrt(3);
float FULL_HEIGHT = sqrt(3) / 2;
float UHLF_HEIGHT = FULL_HEIGHT - BHLF_HEIGHT;

Tri tri = new Tri(0, 0, 100, 0.01, true);

Tri[] tris = new Tri[3];

void setup () {
  size(500, 700);
  frameRate(50);
  strokeWeight(1.5);
  stroke(32);
  noFill();
  tri.p = 1;
  
  tris[0] = new Tri(-0.5, BHLF_HEIGHT, 100, 0.01, false);
  tris[1] = new Tri(0, -FULL_HEIGHT + BHLF_HEIGHT, 100, 0.01, false);
  tris[2] = new Tri(0.5, BHLF_HEIGHT, 100, 0.01, false);
}

void draw () {
  fill(255, 200);
  rect(0, 0, width, height);
  //background(255, 255, 255, 50);
  noFill();
  translate(width/2, height/2);
  //rotate(-PI*float(frameCount)/100);
  if (flip) scale(-1);
  tri.calcPoints();
  tri.draw();
  for (int i = 0; i < tris.length; i++) {
    try {
      tris[i].update();
      tris[i].calcPoints();
      tris[i].draw();
    } catch (NullPointerException e) {}
  }
  scale -= 0.01;
  scale = constrain(scale, min_scale, max_scale);
  
  if (frameCount % 60 == 0) {    
    
    for (int i = 0; i < tris.length; i++) {
      try {
        tris[i].p = 0;
      } catch (NullPointerException e) {}
    }
    scale = max_scale;
    flip = !flip;
  }
}

class Tri {
  float x, y, r, s, p;
  float xo, yo;
  color c;
  boolean f;
  
  float x1, y1, x2, y2, x3, y3;
  
  Tri (float x, float y, float r, float s, boolean f) {
    this.x = x * scale * r/2;
    this.y = y * scale * r/2;
    this.xo = x;
    this.yo = y;
    this.r = r/2;
    this.s = s*2;
    this.f = f;
    this.p = 0;
  }
  
  void calcPoints () { 
    int m = 1;
    if (f) m = -1;
    
    float rm = r + 1;
    
    this.x = xo * scale * scale * rm;
    this.y = yo * scale * scale * rm;
    
    x1 = x;
    x2 = x - 0.5 * rm * scale * scale * p;
    x3 = x + 0.5 * rm * scale * scale * p;
    
    y1 = y - UHLF_HEIGHT * rm * scale * scale * p * m;
    y2 = y + BHLF_HEIGHT * rm * scale * scale * p * m;
    y3 = y + BHLF_HEIGHT * rm * scale * scale * p * m;
  }
  
  void update () {
    p += s;
    p = constrain(p, 0, 1);
  }
  
  void draw () {
    if (x1 == 0) {
      calcPoints();
    }
    beginShape();
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x3, y3);
    endShape(CLOSE);
  }
}
