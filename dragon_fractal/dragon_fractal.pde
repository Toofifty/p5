// VARIABLES
public int fractalCount = 0;
public Fractal fractal;

/** Setup sketch */
public void setup() {
  size(800, 800);
  smooth(8);
  frameRate(60);
  background(32);
  fill(124, 14, 194);
  stroke(128);
  // create main fractal in centre
  fractal = new Fractal(256, width / 2, height / 2, false, true);
}

/** Draw frame */
public void draw() {
  background(32);
  fractal.draw();
}

/** Get key press. Space to increment, r to reset */
public void keyPressed() {
  if (key == ' ') {
    // duplicate fractal and slide
    fractal.createChildren();
    fractal.slide();
    print("Created " + fractalCount + " boxes. \n");
    fractalCount = 0;
  } else if (key == 'r') {
    // reset
    fractal = new Fractal(512, width / 2, height / 2, false, true);
  }
}

/** Fractal class (one square) */
public class Fractal {
  // attributes
  public float size;
  public float x, y;
  public float x1, x2, y1, y2;
  public boolean axis; // true:vert false:horiz
  public boolean dir;  // true:up/left false:down/right
  public Fractal[] children;
  
  // counters
  public int t = 0;
  
  // flags
  public boolean animate = false;
  
  /** Create square at x, y, sliding <dir>(up|left/down|right) axis <vert> */
  public Fractal(float size, float x, float y, boolean vert, boolean dir) {
    this.size = size;
    this.x = x;
    this.y = y;
    this.axis = vert;
    this.dir = dir;
    fractalCount++;
  }
  
  /** Begin slide across */
  public void slide() {
    if (children != null) {
      for (Fractal child : children) {
        child.slide();
      }
    }
    if (axis) // vertical
      y1 = y;
    else      // horizontal
      x1 = x;      
      
    animate = true;
  }
  
  /** Slide smoothly */
  public void animate() {
    if (children != null && children[1].children != null) {
      for (Fractal child : children) {
        child.animate();
      }
    } else {
      if (y1 != 0) {
        // slide on y axis
        y = y1 + (dir ? -0.25F : 0.25F) * (sin((t / 100F - 0.5F) * PI) + 1) * size;
      } else if (x1 != 0) {
        // slide on x axis
        x = x1 + (dir ? 0.25F : -0.25F) * (sin((t / 100F - 0.5F) * PI) + 1) * size;
      }
      if (t >= 100) {
        // set in position
        animate = false;
        if (x1 != 0) x = x1 + (dir ? 0.5F : -0.5F) * size;
        if (y1 != 0) y = y1 + (dir ? -0.5F : 0.5F) * size;
      }
      ++t;
    }
  }
  
  /** Duplicate into 4 children */
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
  
  /** Draw if lowest in heirarchy, else draw children */
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
