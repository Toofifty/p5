/*=======================

  Peeling Cubes
  
  @author: Toofifty

  =====================*/
  
// CUSTOM VALUES
public final int boxSize = 100;   // size of each box
public final int triSize = 82;   // size of each triangle
public final float rate = 0.02F; // speed of animation
public final color background = color(32);

// VARIABLES
public Box mainBox;
public Box zExtrude;
public Box[] xExtrude = new Box[2];
public Box[] yExtrude = new Box[4];

public Tri[] triRing = new Tri[24];

// STAGES: 0 1x1 box, extrudes 7 other boxes
//         1 rotate 90d on y axis
//         2 break off triangles and dissolve outer
//         3 rotate 90d on y axis to loop
public int stage = 0;

// 0 zExtrude [1]; 1 xExtrudes [2]; 2 yExtrudes [4]
public int extrudeStage = 0;

// COUNTERS
public float extrude = 0;
public float yRotate = 0;

// CONSTANTS
public final float SQ3 = sqrt(3);      // sqrt(3)
public final float SQ3D2 = SQ3 / 2F;   // sqrt(3) / 2
public final float oDSQ3 = 1F / SQ3;   // 1 / sqrt(3)
public final float hDSQ3 = oDSQ3 / 2F; // 1 / 2 / sqrt(3)

public void setup() {
  size(600, 600, P3D);
  ortho();
  //fill(32);
  noFill();
  strokeWeight(2);
  smooth(8);
  frameRate(60);
  stroke(255);
  
  mainBox = new Box(0, 0, 0);
}

public void draw() {
  background(background);
  translate(width / 2, height / 2);
  iso();
  doRotate();
  mainBox.draw();
  if (stage == 0) extrude();
  if (stage == 2) dissolve();
  if (zExtrude == null || stage > 1) return;
  zExtrude.draw();
  if (xExtrude[0] == null) return;
  xExtrude[0].draw();
  xExtrude[1].draw();
  if (yExtrude[0] == null) return;
  yExtrude[0].draw();
  yExtrude[1].draw();
  yExtrude[2].draw();
  yExtrude[3].draw();
}

public void reset() {
  zExtrude = null;
  xExtrude = new Box[2];
  yExtrude = new Box[4];
  triRing = new Tri[24]; 
  
}

public void doRotate() {
  if (stage == 1 || stage == 3) {
    yRotate += rate;
    if (yRotate >= 1) {
      yRotate = 0;
      stage++;
    }
    rotateY(sinLerp(yRotate) * PI / 4);
  }
}

public void extrude() {
  switch(extrudeStage) {
  case 0:
    if (zExtrude == null) {
      zExtrude = new Box(0, 0, -1);
      zExtrude.d = 0;
    }
    extrude += rate * 3;
    zExtrude.d = sinLerp(extrude) * boxSize / 2;
    if (extrude >= 1) {
      extrudeStage++;
      extrude = 0;
    }
    break;
  case 1:
    if (xExtrude[0] == null) {
      xExtrude[0] = new Box(1, 0, 0);
      xExtrude[1] = new Box(1, 0, -1);
      xExtrude[0].w = 0;
      xExtrude[1].w = 0;
    }
    extrude += rate * 3;
    xExtrude[0].w = sinLerp(extrude) * boxSize / 2;
    xExtrude[1].w = xExtrude[0].w;
    if (extrude >= 1) {
      extrudeStage++;
      extrude = 0;
    }
    break;
  case 2:
    if (yExtrude[0] == null) {
      yExtrude[0] = new Box(0, 1, 0);
      yExtrude[1] = new Box(0, 1, -1);
      yExtrude[2] = new Box(1, 1, 0);
      yExtrude[3] = new Box(1, 1, -1);
      yExtrude[0].h = 0;
      yExtrude[1].h = 0;
      yExtrude[2].h = 0;
      yExtrude[3].h = 0;
    }
    extrude += rate * 3;
    yExtrude[0].h = sinLerp(extrude) * boxSize / 2;
    yExtrude[3].h = yExtrude[2].h = yExtrude[1].h = yExtrude[0].h;
    if (extrude >= 1) {
      extrudeStage = 0;
      extrude = 0;
      stage++;
    }
    break;
  }
}

public void dissolve() {
  if (triRing[0] == null) {
    createTris();
  }
  unIso();
  float offset = 0;
  for (Tri tri : triRing) {
    final float distance = dist(tri.x, tri.y, 0, 0);
    if (distance > SQ3 * triSize / 2 && tri.size > 0) {
      tri.size = min(tri.size, tri.size - rate * 50 - offset);
      tri.draw();
    }
    offset += 0.2F;
  }
  if (triRing[0].size <= 0) {
    stage = 0;
    reset();
  }
}

public void createTris() {
  int c = 0;
  
  for(int i = 0; i < 4; i++) {
    int n = int(8 - 2 * abs(1.5 - i));
    println(n);
    float x = -SQ3 / 2F - oDSQ3 + (i * SQ3D2);
    float y = 1F + (i >= 2 ? (3 - i) : i) / 2F;
    for (int j = 0; j < n; j++) {
      if (j % 2 == 0 && i < 2 || j % 2 != 0 && i >=2) {
        triRing[c] = new Tri(triSize, x + 1F / 2F / SQ3, j / 2F - y, true);
      } else {
        triRing[c] = new Tri(triSize, x, j / 2F - y, false);
      }
      c++;
    }    
  }
}

/** Get a smoothed sin value from linear */
public float sinLerp(float x) {
  return sin((x - 0.5F) * PI) + 1;
}

/** Set angles to iso */
public void iso() {
  rotateX(-0.6153187F);
  rotateY(PI / 4);
}

/** Set angles back from iso */
public void unIso() {
  rotateY(-PI / 4);
  rotateX(0.6153187F);
}

public class Box {
  
  // attributes
  public float x, y, z;
  public float w, h, d; // size x, y, z
  
  public Box(float x, float y, float z) {
    w = h = d = boxSize;
    this.x = (x - 0.5F) * boxSize;
    this.y = (y - 0.5F) * boxSize;
    this.z = (z + 0.5F) * boxSize;
  }
  
  public void setSize(float w, float h, float d) {
    this.w = w;
    this.h = h;
    this.d = d;
  }
  
  public void draw() {
    translate(x, y, z);
    translate((boxSize - w) / -2, (boxSize - h) / -2, (boxSize - d) / 2);
    box(w, h, d);
    translate((boxSize - w) / 2, (boxSize - h) / 2, (boxSize - d) / -2);
    translate(-x, -y, -z);
  }
}

public class Tri {
  
  // attributes
  private float x, y;
  private float size;
  private final boolean left;

  public Tri(float size, float x, float y, boolean left) {
    this.size = size;
    this.left = left;
    this.x = x * size;
    this.y = y * size;
  }
  
  public void draw() {    
    translate(x, y);
    stroke(255);
    if (left) {
      triangle(
        size * -oDSQ3, size *    0,
        size *  hDSQ3, size *  0.5,
        size *  hDSQ3, size * -0.5
      );
    } else {
      triangle(
        size *  oDSQ3, size *    0,
        size * -hDSQ3, size *  0.5,
        size * -hDSQ3, size * -0.5
      );
    }
    translate(-x, -y);
  }  
}
