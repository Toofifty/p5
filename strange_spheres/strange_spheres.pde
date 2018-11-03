/*------------------------------------------
  "Strange Spheres"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

int num_dots = 3;   // will actually be cubed
float dot_sep = 80;
float dot_size = 50;

float speed = 100;

int phase = 0;

Dot[] dots = new Dot[num_dots * num_dots * num_dots];

void setup() {
  size(400, 400, P3D);
  ortho();
  fill(32);
  //stroke(32);
  strokeWeight(5);
  noStroke();
  background(255);
  smooth();
  
  float back = float(num_dots - 1) * dot_sep / 2;
  
  for (int i = 0; i < num_dots; i++) {
    for (int j = 0; j < num_dots; j++) {
      for (int k = 0; k < num_dots; k++) {
        dots[i * num_dots * num_dots + j * num_dots + k] =
          new Dot(i * dot_sep - back, j * dot_sep - back, k * dot_sep - back, color(32));
      }
    }
  }
}

void draw() {
  translate(width/2, height/2);
  doRotate(true);
  
  background(32);
  for (Dot d : dots) {
    d.draw();
  }
  if (frameCount % (speed/2) == 0 && frameCount % speed != 0) {
    phase++;
    if (phase >= 3) {
      phase = 0;
    }
  }
}

float getRotate(float slow) {
  return PI * sin(frameCount * PI / speed) / 4 + PI / 4;
}

void doRotate(boolean reverse) {
  if (reverse) {
    rotateX(-0.6153187f);
    rotateY(PI/4);
    if (phase == 0) rotateY(getRotate(10));
    if (phase == 1) rotateX(-getRotate(10));
    if (phase == 2) rotateZ(getRotate(10));
  } else {
    if (phase == 2) rotateZ(-getRotate(10));
    if (phase == 1) rotateX(getRotate(10));
    if (phase == 0) rotateY(-getRotate(10));
    rotateY(-PI/4);
    rotateX(0.6153187f);
  }
}

class Dot {
  float x, y, z;
  color c;
  
  public Dot(float x, float y, float z, color c) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.c = c;
  }
  
  public void draw() {
    translate(x, y, z);
    doRotate(false);
    fill(lerpColor(color(255, 255, 0), color(0, 255, 255), sin(frameCount / PI / 10)/2 + 0.5));
    ellipse(0, 0, dot_size, dot_size);
    //rect(0, 0, dot_size, dot_size);
    doRotate(true);
    translate(-x, -y, -z);
  }
}