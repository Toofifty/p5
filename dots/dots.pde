// Circle size fun!

float maxsize = 30;

float spread = 200;

int columns;
int rows;

float _mx = 0;
float _my = 1;

float t = 0;

boolean anim = false;

Circle[] circles;

void setup () {
  size(500, 500);
  background(0);
  noStroke();
  smooth(8);
  
  columns = (int) round(width / maxsize) + 1;
  rows = (int) round(height / maxsize) + 1;
  
  circles = new Circle[columns * rows];
  
  for (int j = 0; j < columns; j++) {
    for (int i = 0; i < rows; i++) {
      circles[j * rows + i] = new Circle(j * maxsize, i * maxsize);
    }
  }
}

void draw () {
  background(0);
  if (anim) {
    _mx = 100 * sin(t * PI / 100) + width/2;
    _my = 100 * cos(t * PI / 100) + height/2;
    t++;
  }
  for (int i = 0; i < circles.length; i++) {
    circles[i].draw();
    circles[i].seconddraw(32);
    circles[i].seconddraw(16);
  }
  if (t < 300 && anim) {
    //saveFrame("dots-"+t+".png");
  }
}

float mx() {
  if (anim) return _mx;
  return mouseX;
}

float my() {
  if (anim) return _my;
  return mouseY;
}

class Circle {
  float _x;
  float _y;
  float _s;
  
  public Circle (float x, float y) {
    _x = x;
    _y = y;
  }
  
  public float getsize () {
    float d = dist(_x, _y, mx(), my());
    float size = maxsize * d * 2 / spread;
    size = min(size, sqrt(maxsize * maxsize * 2));
    return size;
  }
  
  public float getangle () {
    return atan((mx() - _x) / (my() - _y));
  }
  
  public void draw () {
    _s = getsize();
    fill(255);
    ellipse(_x, _y, _s, _s);
  }
  
  public void seconddraw (float factor) {
    _s = getsize();
    if (_s == sqrt(maxsize * maxsize * 2)) return;
    fill(255, 50);
    ellipse(_x + (_x - mx()) / factor, _y + (_y - my()) / factor, _s, _s);
  }
}
