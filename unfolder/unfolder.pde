/*------------------------------------------
  "Better Trixel Folder"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

float max_scale = 2;
float min_scale = 1;

float scale = max_scale;
int flip = 1;

float BHLF_HEIGHT = 0.5 / sqrt(3);
float FULL_HEIGHT = sqrt(3) / 2;
float UHLF_HEIGHT = FULL_HEIGHT - BHLF_HEIGHT;

color c1 = color(41, 81, 109);
color c2 = color(45, 136, 45);

Tri tri = new Tri(0, 0, 100, 0.01, color(32), true);

Tri[] tris = new Tri[3];

void setup () {
  size(250, 250);
  frameRate(50);
  strokeWeight(1);
  stroke(32);
  tri.p = 1;
  
  /*tris[0] = new Tri(0, 2 * FULL_HEIGHT, 100, 0.01, color(32), true);
  tris[1] = new Tri(0, FULL_HEIGHT + BHLF_HEIGHT, 100, 0.01, color(32), false);
  tris[2] = new Tri(-0.5, FULL_HEIGHT, 100, 0.01, color(32), true);
  tris[3] = new Tri(-0.5, BHLF_HEIGHT, 100, 0.01, color(32), false);
  tris[4] = new Tri(-1, 0, 100, 0.01, color(32), true);
  tris[5] = new Tri(-1, -UHLF_HEIGHT, 100, 0.01, color(32), false);
  tris[6] = new Tri(-1.5, -FULL_HEIGHT, 100, 0.01, color(32), true);
  
  tris[7] = new Tri(-0.5, -FULL_HEIGHT, 100, 0.01, color(32), true);
  tris[8] = new Tri(0, -FULL_HEIGHT + BHLF_HEIGHT, 100, 0.01, color(32), false);
  tris[9] = new Tri(0.5, -FULL_HEIGHT, 100, 0.01, color(32), true);
  tris[10] = new Tri(1, -FULL_HEIGHT + BHLF_HEIGHT, 100, 0.01, color(32), false);
  tris[11] = new Tri(1.5, -FULL_HEIGHT, 100, 0.01, color(32), true);
  
  tris[12] = new Tri(1, 0, 100, 0.01, color(32), true);
  tris[13] = new Tri(0.5, BHLF_HEIGHT, 100, 0.01, color(32), false);
  tris[14] = new Tri(0.5, FULL_HEIGHT, 100, 0.01, color(32), true);*/
  
  tris[0] = new Tri(0, -FULL_HEIGHT + BHLF_HEIGHT, 100, 0.01, color(32), false);
  tris[1] = new Tri(0, -FULL_HEIGHT + BHLF_HEIGHT, 100, 0.01, color(32), false);
  tris[2] = new Tri(0, -FULL_HEIGHT + BHLF_HEIGHT, 100, 0.01, color(32), false);
  
  
  tri.beginFade(c2, c1);
  for (int i = 0; i < tris.length; i++) {
    tris[i].c = c1;
  }
  
}

void draw () {
  background(255);
  translate(width/2, height/2);
  //rotate(-PI*float(frameCount)/100);
  rotate(PI/2);
  scale(flip);
  tri.update();
  tri.calcPoints();
  for (int i = 0; i < tris.length; i++) {
    tris[i].update();
    tris[i].calcPoints();
    tris[i].draw();
  }
  tri.draw();
  scale -= 0.01;
  scale = constrain(scale, min_scale, max_scale);
  
  if (frameCount % 100 == 0) {    
    flip = flip == 1 ? -1 : 1;
    
    if (flip == 1) {
      tri.beginFade(c2, c1);
      for (int i = 0; i < tris.length; i++) {
        tris[i].c = c1;
      }
    } else {
      tri.beginFade(c1, c2);
      for (int i = 0; i < tris.length; i++) {
        tris[i].c = c2;
      }
    }
    
    for (int i = 0; i < tris.length; i++) {
      tris[i].p = -1;
    }
    scale = max_scale;
  }
}

class Tri {
  float x, y, r, s, p;
  float xo, yo;
  color oc, c;
  boolean f;
  float cl;
  color c1, c2;
  boolean fading;
  
  float x1, y1, x2, y2, x3, y3;
  
  Tri (float x, float y, float r, float s, color c, boolean f) {
    this.x = x * scale * r;
    this.y = y * scale * r;
    this.xo = x;
    this.yo = y;
    this.r = r;
    this.s = s*2;
    this.oc = c;
    this.f = f;
    this.p = -1;
  }
  
  void calcPoints () { 
    int m = 1;
    if (f) m = -1;
    
    float rm = r + 1;
    
    this.x = xo * scale * rm;
    this.y = yo * scale * rm;
    
    x1 = x;
    x2 = x - 0.5 * rm * scale;
    x3 = x + 0.5 * rm * scale;
    
    y1 = y - UHLF_HEIGHT * rm * scale * p * m;
    y2 = y + BHLF_HEIGHT * rm * scale * m;
    y3 = y + BHLF_HEIGHT * rm * scale * m;
  }
  
  void update () {
    p += s;
    p = constrain(p, -1, 1);
    
    if (fading) {
      c = lerpColor(c1, c2, cl);
      cl += 0.01;
      if (cl >= 1) {
        cl = 0;
        fading = false;
      }
    }
  }
  
  void beginFade (color c1, color c2) {
    this.c1 = c1;
    this.c2 = c2;
    cl = 0;
    this.fading = true;
  }
  
  void draw () {
    if (x1 == 0) {
      calcPoints();
    }
    rotate(PI/1.5);
    fill(c);
    stroke(c);
    beginShape();
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x3, y3);
    endShape(CLOSE);
  }
}
