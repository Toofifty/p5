final float G = 9.8;
final int DROPS = 100;
final float HUE_SEP = 100;
final int MIN = 2;
final int MAX = 7;

Drop[] rain = new Drop[DROPS];
PGraphics colliders;

void setup() {
  size(800, 600);
  noStroke();
  background(32);
  colorMode(HSB, 255);
  
  colliders = createGraphics(width, height);
  colliders.beginDraw();
  colliders.background(32);
  colliders.fill(255, 255, 255);
  colliders.strokeWeight(4);
  colliders.endDraw();
  
  for (int i = 0; i < DROPS; i++) {
    rain[i] = new Drop(int(random(width)), random(MIN, MAX));
  }
}

void draw() {
  image(colliders, 0, 0);
  rain[int(random(DROPS))].release();
  rain[int(random(DROPS))].release();
  for (Drop d : rain) {
    d.checkCollide();
    d.applyG();
    d.draw();
  }
}

class Drop {
  
  int x;
  int y;
  float w;
  float s;
  
  float vy;
  float vx;
  
  int hue;
  
  boolean released = false;
  
  Drop(int x, float w) {
    this.x = x;
    this.w = w;
    this.y = 0;
    this.s = 0;
    this.hue = 0;
  }
  
  void applyG() {
    if (!this.released) return;
    this.vy += G / 600F * w;
    this.y += vy;
    this.x += vx;
    
    if (y > height) {
      if (this.vy < 0.5F) this.reset();
      this.vy *= -2 / random(3, 5);
    }
    
    this.s = vy / 2F;
    this.hue = int(255 * noise(x / HUE_SEP, y / HUE_SEP));
  }
  
  void release() {
    this.released = true;
  }
  
  void reset() {
    this.released = false;
    this.y = 0;
    this.vy = this.s = 0;
    this.x = int(random(width));
  }
  
  void checkCollide() {
    if (colliders.get(x, y) != color(32)) {
      this.vy *= -1 / 3F;
      this.vx *= -1 / 3F;
      boolean flag = false;
      int checked = 1;
      while (!flag) {
        if (colliders.get(x + checked, y) == color(32)) {
          this.vx += 1;
          flag = true;
        } else if (colliders.get(x - checked, y) == color(32)) {
          this.vx -= 1;
          flag = true;
        } else if (checked > 50) {
          flag = true;
          this.y += 2;
        } else {
          checked++;
        }
      }
    }
  }
  
  void draw() {
    if (!this.released) return;
    fill(hue, 128, 255);
    translate(x, y);
    triangle(-w / 2, 0, w / 2, 0, 0, -w * s);
    ellipse(0, 0, w, w);
    translate(-x, -y);
  }
  
}

public void mouseDragged() {
  colliders.beginDraw();
  colliders.stroke(255, 255, 255);
  colliders.line(mouseX, mouseY, pmouseX, pmouseY);
  colliders.endDraw();
}
