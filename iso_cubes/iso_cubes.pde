/*===========================

  iso cubes
  
  
  
  @author: Toofifty

===========================*/
public Box box;
public final int boxsize = 243;
public float spinT = 0F;
public float rollT = 0F;
public float roll2T = 0F;

public void setup() {
  size(1920, 1080, P3D);
  stroke(255);
  strokeWeight(2);
  smooth(8);
  frameRate(60);
  //fill(32);
  noFill();
  ortho(0, width, 0, height, 0, 10000);
  box = new Box(boxsize);
  box.animating = true;
}

public void draw() {
  background(32);
  translate(width / 2, height / 2);
  rotateX(-0.6153187f);
  rotateY(PI/4);
  rotateX(getRoll2());
  rotateY(getSpin());
  rotateZ(getRoll());
  if (box.checkSize() >= boxsize) {
    println("Restarting anim...");
    box = new Box(boxsize);
    spinT = 0F;
    rollT = 0F;
    roll2T = 0F;
    box.animating = true;
  }
  box.draw();
}

public float getSpin() {
  if (!box.spreading || spinT > 1) {
    return 0;
  }
  spinT += 0.005F;
  return PI/4 * (sin((spinT - 0.5) * PI) + 1);
}

public float getRoll() {
  if (box.spreading || rollT > 1) {
    return 0;
  }
  rollT += 0.01F;
  return PI/4 * (sin((rollT - 0.5) * PI) + 1);
}

public float getRoll2() {
  if (roll2T > 1) {
      noFill();
      box.spreadChildren();
      box.setZooming();
  }
  if (box.spreading || rollT <= 1) {
    return 0;
  }
  roll2T += 0.01F;
  return PI/4 * (sin((roll2T - 0.5) * PI) + 1);
}

public class Box {
  public float x;
  public float y;
  public float z;
  public float size;
  public float msize;
  public Box[] children;
  
  public boolean spreading = false;
  public boolean zooming = false;
  public boolean animating = false;
  
  public float zoomt = 0;
  
  public float lineLength = 0;
  
  public Box(float size) {
    this.size = size;
    this.msize = size;
  }
  
  public Box(float size, float x, float y, float z) {
    this.size = size;
    this.msize = size;
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public void addChildBox(int i, int j, int k, float cs) {
    Box child = new Box(cs, x + i * cs, y + j * cs, z + k * cs);
    children[(i + 1) + (j + 1) * 3 + (k + 1) * 9] = child;
  }
  
  public void animate() {
    lineLength += 0.01F;
    if (lineLength >= 1) {
      box.split();
      animating = false;
    }
    float s2 = size / 2;
    float s6 = size / 6;
    float sl = size * lineLength;
    
    // most confusing shit ever
    // left vert
    line(-s2, s2, s6, -s2, s2 - sl, s6);
    line(-s2, -s2, -s6, -s2, -s2 + sl, -s6);
    // left horiz
    line(-s2, s6, -s2, -s2, s6, -s2 + sl);
    line(-s2, -s6, s2, -s2, -s6, s2 - sl);
    // right vert
    line(s6, s2, s2, s6, s2 - sl, s2);
    line(-s6, -s2, s2, -s6, -s2 + sl, s2);
    // right horiz
    line(s2, -s6, s2, s2 - sl, -s6, s2);
    line(-s2, s6, s2, -s2 + sl, s6, s2);
    // top 'vert'
    line(s6, -s2, s2, s6, -s2, s2 - sl);
    line(-s6, -s2, -s2, -s6, -s2, -s2 + sl);
    // top 'horiz'
    line(s2, -s2, -s6, s2 - sl, -s2, -s6);
    line(-s2, -s2, s6, -s2 + sl, -s2, s6);
    
    // back right vert
    line(s2, s2, -s6, s2, s2 - sl, -s6);
    line(s2, -s2, s6, s2, -s2 + sl, s6);
    // back right horiz
    line(s2, -s6, -s2, s2, -s6, -s2 + sl);
    line(s2, s6, s2, s2, s6, s2 - sl);
    // back left vert
    line(-s6, s2, -s2, -s6, s2 - sl, -s2);
    line(s6, -s2, -s2, s6, -s2 + sl, -s2);
    // back left horiz
    line(s2, s6, -s2, s2 - sl, s6, -s2);
    line(-s2, -s6, -s2, -s2 + sl, -s6, -s2);
    // bottom 'vert'
    line(-s6, s2, s2, -s6, s2, s2 - sl);
    line(s6, s2, -s2, s6, s2, -s2 + sl);
    // bottom 'horiz'
    line(s2, s2, s6, s2 - sl, s2, s6);
    line(-s2, s2, -s6, -s2 + sl, s2, -s6);
  }
  
  public void split() {
    children = new Box[27];
    float cs = size / 3;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        for (int k = -1; k < 2; k++) {
          addChildBox(i, j, k, cs);
        }
      }
    }
  }
  
  public void spreadChildren() {
    spreading = true;
    for (Box child : children) {
      child.spreading = true; // hopefully i'm not on some sex offenders list now...
    }
  }
  
  public void spread() {
    x = x * 1.01F;
    y = y * 1.01F;
    z = z * 1.01F;
  }
  
  public float checkSize() {
    if (children != null) {
      return children[13].size;
    } else {
      return 0;
    }
  }
  
  public void setZooming() {
    children[13].zooming = true;
    /*for (Box child : children) {
      child.zooming = true;
    }*/
  }
  
  public void zoom() {
    size = msize + msize * (sin((zoomt - 0.5F) * PI) + 1);
    zoomt += 0.005F;
  }
  
  public void draw() {
    if (children != null) {
      for (Box child : children) {
        child.draw();
      }
    } else {
      if (zooming) zoom();
      if (spreading) spread();
      if (animating) animate();
      float distance = max(1, (dist(x, y, z, 0, 0, 0) - size * 2) * 2 - 100);
      if (distance > 200) {
        return;
      } else {
        stroke(255, 255F / distance);
        //fill(32, 255F / distance);
      }
      translate(x, y, z);
      box(size);
      translate(-x, -y, -z);
    }
  }
}
