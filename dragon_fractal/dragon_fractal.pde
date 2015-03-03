public int drawCount = 0;
public Fractal fractal;

public void setup() {
  size(600, 600);
  smooth(8);
  stroke(32);
  noStroke();
  frameRate(30);
  background(32);
  fill(128);
  fractal = new Fractal(256, width / 2, height / 2, false, true);
}

public void draw() {
  
}

public void keyPressed() {
  if (key == ' ') {
    background(32);
    fractal.draw();
    print("Drew " + drawCount + " boxes.");
    drawCount = 0;
    fractal.createChildren();
    fractal.slide();
  }
}

public class Fractal {
  
  private float size;
  private float x;
  private float y;
  private boolean axis; // true:vert false:horiz
  private boolean dir; // true:up/left false:down/right
  private Fractal[] children;
  
  public Fractal(float size, float x, float y, boolean vert, boolean dir) {
    this.size = size;
    this.x = x;
    this.y = y;
    this.axis = vert;
    this.dir = dir;
  }
  
  public void slide() {
    if (children != null) {
      for (Fractal child : children) {
        child.slide();
      }
    }
    if (axis) { // vertical
      if (dir) y -= size / 2;
      else y += size / 2;
    } else { // horizontal
      if (dir) x += size / 2;
      else x -= size / 2;
    }
  }
  
  public void createChildren() {
    if (children == null) {
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
    } else {
      for (Fractal child : children) {
        child.createChildren();
      }
    }
  }
  
  public void draw() {
    if (children != null) {
      for (Fractal child : children) {
        child.draw();
      }
    } else {
      rect(x - size / 2F, y - size / 2F, size, size);
      drawCount += 1;
    }
  }
  
}
