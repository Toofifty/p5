int[] c = new int[]{100, 100, 100};
int[] c2 = new int[]{255, 255, 255};
  
class Button {
  PApplet par;
  
  float x, y, w, h;
  String t;
  boolean a = false;
  
  Button (float x, float y, float w, float h, String t, boolean a, PApplet par) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.t = t;
    this.a = a;
    this.par = par;
  }
  
  boolean a () {
    return this.a;
  }
  
  void setactive (boolean a) {
    this.a = a;
  }
  
  boolean inbounds (float mx, float my) {
    if (mx < x || my < y) return false;
    if (mx > x + w || my > y + h) return false;
    return true;
  }
  
  void draw() {
    fill(c[0], c[1], c[2], 100);
    textSize(14);
    if (a) {
      stroke(255, 200);
    } else {
      stroke(0, 100);
    }
    rect(x, y, w, h);
    fill(c2[0], c2[1], c2[2], 100);
    text(t, x + 5, y + 17);
  }
}

abstract class Base {
  PApplet par;
  float x, y, w, h;
  Base(float x, float y, float w, float h, PApplet par) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.par = par;
  }
  
  boolean inbounds (float mx, float my) {
    if (mx < x || my < y) return false;
    if (mx > x + w || my > y + h) return false;
    return true;
  }
  
  abstract void draw();
}

abstract class Slider extends Base {
  float v, min, max;
  float cx, minX, maxX;
  
  Slider(float x, float y, float w, float h, float v, float min, float max, PApplet par) {
    super(x, y, w, h, par);
    this.min = min;
    this.max = max;
    this.v = v;
    
    float relX = v / (max-min);
    float absX = w * relX * 0.8;
    cx = w/10 + absX;
    
    minX = w/10;
    maxX = 9*w/10;
  }
  
  float val () { return v; }
  
  abstract void update(float mx);
  void draw() {
    fill(0, 0, 0, 100);
    rect(x, y, w * 2, h);
    fill(c[0], c[1], c[2], 200);
    rect(x + w/10, y + 5*h/11, 4*w/5, h/11);
    fill(c2[0], c2[1], c2[2], 100);
    ellipse(x + cx, y + h/2, h/2, h/2);
    text(v, x + w + 5, y + 17);
  }
}

class IntSlider extends Slider {  
  IntSlider(float x, float y, float w, float h, int v, int min, int max, PApplet par) {
    super(x, y, w, h, float(v), float(min), float(max), par);
  }
  
  float val () {
    return float(round(v));
  }
  
  void update (float mx) {
    cx = mx - x;
    if (cx > maxX) {
      cx = maxX;
    } else if (cx < minX) {
      cx = minX;
    }
    v = int((cx - w/10) * ((max - min) * 4/5) / w);
  }
  
}

class FloatSlider extends Slider {  
  FloatSlider(float x, float y, float w, float h, float v, float min, float max, PApplet par) {
    super(x, y, w, h, v, min, max, par);
  }
  
  float val () {
    return v;
  }
  
  void update (float mx) {
    cx = mx - x;
    if (cx > maxX) {
      cx = maxX;
    } else if (cx < minX) {
      cx = minX;
    }
    v = (cx - w/10) * ((max - min) * 4/5) / w;
  }
}
