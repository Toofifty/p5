/*===========================

  iso cubes
  
  @author: Toofifty

===========================*/
public Box box;
public final int boxsize = 150;
public float spinT = 0F;
public float rollT = 0F;
public float roll2T = 0F;

public void setup() {
  size(600, 600, P3D);
  smooth(8);
  frameRate(30);
  blendMode(ADD);
  //fill(32);
  noFill();
  ortho(0, width, 0, height, 0, 10000);
  box = new Box(boxsize);
  box.animating = true;
}

public void draw() {
  background(32);
  fill(255);
  text(frameRate, 0, 12);
  noFill();
  translate(width / 2, height / 2);
  rotateX(-0.6153187f);
  rotateY(PI/4);
  rotateX(getRoll2());
  rotateY(getSpin());
  rotateZ(getRoll());
  if (box.checkSize() >= boxsize) {
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
  if (roll2T > 1 && box.triangles == null) {
      noFill();
      box.splitTriangles();
      //box.spreadChildren();
      //box.setZooming();
  }
  if (box.spreading || rollT <= 1 || box.triangles != null) {
    return 0;
  }
  roll2T += 0.01F;
  return PI/4 * (sin((roll2T - 0.5) * PI) + 1);
}

public int count(Object[] array) {
  int c = 0;
  for (Object obj : array) {
    if (obj != null) c++;
  }
  return c;
}

public class Box {
  public float x;
  public float y;
  public float z;
  public float size;
  public float msize;
  public Box[] children;
  public Triangle[] triangles;
  
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
    stroke(255);
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
  
  // split into sub-cubes
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
      child.spreading = true;
    }
  }
  
  public void splitTriangles() {
    triangles = new Triangle[54];
    int c = 0;
    for (int i = 0; i < 6; i++) {
      int n = int(12 - 2 * abs(2.5 - i));
      float x = -sqrt(3) - 1F / sqrt(3) + (i * sqrt(3) / 2);
      float y = 1.5F + (i >= 3 ? (5 - i) : i) / 2F;
      for (int j = 0; j < n; j++) {        
        if (j % 2 == 0 && i < 3 || j % 2 != 0 && i >= 3) {
          triangles[c] = new Triangle(41, x + 1F / 2F / sqrt(3), j / 2F - y, true);
        } else {
          triangles[c] = new Triangle(41, x, j / 2F - y, false);
        }
        c++;
      }
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
    if (triangles != null && triangles[0].spreading) {
      triangles[0].undoIso();
      for (Triangle tri : triangles) {
        tri.draw();
      }
      triangles[0].redoIso();
    } else
    if (children != null) {
      for (Box child : children) {
        child.draw();
      }
    } else {
      if (zooming) zoom();
      if (spreading) spread();
      if (animating) animate();
      
      float distance = min(1, (dist(x, y, z, 0, 0, 0) - size * 2) / 100F);
      if (distance >= 1) return;
      stroke(127, 255 - floor(distance * 255F));
      
      translate(x, y, z);
      box(size);
      translate(-x, -y, -z);
    }
  }
}

public class Triangle {
  public float x;
  public float y;
  public float initx;
  public float inity;
  public float size;
  public boolean left;
  public float spreadT = 0;
  public boolean spreading = true;
  
  public float SQ3 = sqrt(3);
  
  // triangle centre to point ( One Div SQuare root 3 )
  public float oDSQ3 = 1 / sqrt(3);
  // triangle centre to closest edge ( Half Div SQuare root 3 )
  public float hDSQ3 = oDSQ3 / 2;
  
  public Triangle(float size, float x, float y, boolean left) {
    this.size = size;
    this.initx = x * size;
    this.inity = y * size;
    this.left = left;
  }
  
  public void undoIso() {
    rotateY(-PI/4);
    rotateX(0.6153187f);
  }
  
  public void redoIso() {
    rotateX(-0.6153187f);
    rotateY(PI/4);
  }
  
  public void spread() {
    if (!spreading) {
      return;
    } else if (spreadT >= 2 && spreading) {
      x = initx;
      y = inity;
      box.spreadChildren();
      box.setZooming();
      spreading = false;
    } else {
      x = initx + initx * (sin((spreadT - 0.5F) * PI) + 1) / 2;
      y = inity + inity * (sin((spreadT - 0.5F) * PI) + 1) / 2;
      spreadT += 0.01F;
    }
  }
  
  public void draw() {
    spread();
    translate(x, y);
    stroke(255);
    if (left) { // points left
      // point 1:
      //  -oDSQ3, 0
      // point 2:
      //   hDSQ3, 0.5 
      // point 3:
      //   hDSQ3, -0.5
      triangle(
         size * -oDSQ3, size *    0, 
         size *  hDSQ3, size *  0.5,
         size *  hDSQ3, size * -0.5
      );
    } else { // points right
      triangle(
         size *  oDSQ3, size *    0, 
         size * -hDSQ3, size *  0.5,
         size * -hDSQ3, size * -0.5
      );
    }
    translate(-x, -y);
  }
  
}
