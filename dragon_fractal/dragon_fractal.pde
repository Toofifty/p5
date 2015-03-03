public int fractalCount = 0;
public Fractal fractal;

public void setup() {
  size(2560, 1440);
  smooth(8);
  frameRate(60);
  background(32);
  fill(124, 14, 194);
  stroke(128);
  fractal = new Fractal(512, width / 2, height / 2, false, true);
}

public void draw() {
  background(32);
  fractal.draw();
}

public void keyPressed() {
  if (key == ' ') {
    fractal.createChildren();
    fractal.slide();
    print("Created " + fractalCount + " boxes. \n");
    fractalCount = 0;
  } else if (key == 'r') {
    fractal = new Fractal(512, width / 2, height / 2, false, true);
  }
}

public class Fractal {
  
  public float size;
  public float x;
  public float y;
  public boolean axis; // true:vert false:horiz
  public boolean dir; // true:up/left false:down/right
  public Fractal[] children;
  public boolean animate = false;
  
  public float x1;
  public float y1;
  public float x2;
  public float y2;
  public int t = 0;
  
  public Fractal(float size, float x, float y, boolean vert, boolean dir) {
    this.size = size;
    this.x = x;
    this.y = y;
    this.axis = vert;
    this.dir = dir;
    ++fractalCount;
  }
  
  public void slide() {
    if (children != null) {
      for (Fractal child : children) {
        child.slide();
      }
    }
    if (axis) { // vertical
      y1 = y;
      if (dir) y2 = y - size / 2;
      else y2 = y + size / 2;
    } else { // horizontal
      x1 = x;
      if (dir) x2 = x + size / 2;
      else x2 = x - size / 2;
    }
    animate = true;
  }
  
  public void animate() {
    if (children != null && children[1].children != null) {
      for (Fractal child : children) {
        child.animate();
      }
    } else {
      if (y1 != 0) {
        y = y1 + (dir ? -0.25F : 0.25F) * (sin((t / 100F - 0.5F) * PI) + 1) * size;
      } else if (x1 != 0) {
        x = x1 + (dir ? 0.25F : -0.25F) * (sin((t / 100F - 0.5F) * PI) + 1) * size;
      } else {
        print("No transform given.");
      }
      if (t >= 100) {
        animate = false;
        if (x1 != 0) x = x1 + (dir ? 0.5F : -0.5F) * size;
        if (y1 != 0) y = y1 + (dir ? -0.5F : 0.5F) * size;
      }
      ++t;
    }
  }
  
  public void createChildren() {
    if (children != null) {
      for (Fractal child : children) {
        child.createChildren();
      }
    } else {
      children = new Fractal[4];
      if (axis) { // vertical
        children[0] = new Fractal(size / 2, x - size / 4, y - size / 4, false,  true);
        children[1] = new Fractal(size / 2, x + size / 4, y - size / 4, false,  true);
        children[2] = new Fractal(size / 2, x - size / 4, y + size / 4, false, false);
        children[3] = new Fractal(size / 2, x + size / 4, y + size / 4, false, false);        
      } else { // horizontal
        children[0] = new Fractal(size / 2, x - size / 4, y - size / 4,  true,  true);
        children[1] = new Fractal(size / 2, x + size / 4, y - size / 4,  true, false);
        children[2] = new Fractal(size / 2, x - size / 4, y + size / 4,  true,  true);
        children[3] = new Fractal(size / 2, x + size / 4, y + size / 4,  true, false);
      }
    }
  }
  
  public void draw() {
    if (children != null) {
      for (Fractal child : children) {
        child.draw();
      }
    } else {
      if (animate) animate();
      rect(x - size / 2F, y - size / 2F, size, size);
    }
  }
  
}
