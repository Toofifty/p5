/*=======================

  Isometric Trickery
  
  @author: Toofifty
  
  =======================
  
  TODO:
    - Toggle extra rotations on/off
    - Toggle stage 1 on/off
    - Custom foreground (line) colour

  =====================*/


// CUSTOM VALUES
public final int boxSize = 150;  // main box size (sub boxes are /3)
public final int triSize = 41;   // triangle size
public final float rate = 0.005F; // speed of the animation
public final color background = color(32);

// VARIABLES
public Box box;
public float xroll; // [0, 1] of x rotation
public float yroll; // [0, 1] of y rotation
public float zroll; // [0, 1] of z rotation

// STAGES: 0 = draw lines + rotate
//         1 = split into cubes + rotate
//         2 = split into triangles + spread
//         3 = spread cubes
public int stage = 0;

// CONSTANTS
public final float SQ3 = sqrt(3);      // sqrt(3)
public final float SQ3D2 = SQ3 / 2F;   // sqrt(3) / 2
public final float oDSQ3 = 1F / SQ3;   // 1 / sqrt(3)
public final float hDSQ3 = oDSQ3 / 2F; // 1 / 2 / sqrt(3)

/** Setup sketch */
public void setup() {
  size(600, 600, P3D);
  smooth(8);
  frameRate(30); // 60 for fast computers
  strokeWeight(2);
  noFill();
  ortho(0, width, 0, height, 0, 10000);
  box = new Box(boxSize);
  println("STAGE: " + stage);
}

/** Draw frame */
public void draw() {
  // refresh frame
  background(background);
  // centre
  translate(width / 2, height / 2);
  // rotate to iso
  iso();
  // rotate and manage stages
  doRotations();
  box.draw();
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

/** Do smooth rotations and advance stages */
public void doRotations() {
  if (zroll < 1 && stage == 0) {
    zroll += rate;
    rotateZ(PI / 4 * sinLerp(zroll));
    
  } else if (xroll < 1 && stage == 1) {
    xroll += rate;
    rotateX(PI / 4 * sinLerp(xroll));
    
  } else if (stage == 2) {
    // this stage is handled in the triangle class
    return;
    
  } else if (yroll < 1 && stage == 3) {
    box.setZooming(true);
    box.setSpreading(true);
    yroll += rate;
    rotateY(PI / 4 * sinLerp(yroll));
    
  } else {
    // increment stage
    stage++;
    if (stage > 3) {
      // reset counters
      stage = 0;
      xroll = 0;
      yroll = 0;
      zroll = 0;
      // reset box
      box = new Box(boxSize);
      println("RESET ANIM");
    }
    println("STAGE: " + stage);
  }
}

/** Get a smoothed sin value from linear */
public float sinLerp(float x) {
  return sin((x - 0.5F) * PI) + 1;
}

/** Box class */
public class Box {
  
  // attributes
  private float x, y, z;
  private float size;
  private final float initialSize;
  
  // sub shapes
  private Box[] subBoxes;
  private Triangle[] subTris;
  
  // counters [0, 1]
  public float zoom;
  public float line;
  
  // flags
  public boolean zooming;
  public boolean spreading;
  
  /** Create a box at screen centre */
  public Box(float size) {
    this.size = size;
    this.initialSize = size;
    // x, y, z will stay at 0, 0, 0
  }
  
  /** Create a box at custom coords */
  private Box(float size, float x, float y, float z) {
    this.size = size;
    this.initialSize = size;
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /** Set the centre box to zooming */
  public void setZooming(boolean flag) {
    if (subBoxes[13].zooming != flag)
      subBoxes[13].zooming = flag;
  }
  
  /** Set all boxes to spreading */
  public void setSpreading(boolean flag) {
    if (subBoxes[0].spreading != flag) {
      for (Box sub : subBoxes) {
        sub.spreading = flag;
      }
    }
  }
  
  /** Increase size of box */
  private void zoom() {
    zoom += rate;
    size = initialSize * (sinLerp(zoom) + 1);
  }
  
  /** Move coordinates away from 0, 0, 0 */
  private void spread() {
    x *= (1 + rate * 2);
    y *= (1 + rate * 2);
    z *= (1 + rate * 2);
  }
  
  /** Add a subBox at i, j, k offset from centre */
  private void addSubBox(int i, int j, int k, float boxSize) {
    Box subBox = new Box(boxSize, 
      x + boxSize * i, y + boxSize * j, k + boxSize * k
    );
    
    final int id = (i + 1) + (j + 1) * 3 + (k + 1) * 9;
    subBoxes[id] = subBox;
  }
  
  /** Draw the lines that split the main box */
  private void animateLines() {
    line += rate;
    
    if (line > 1) line = 1;
    
    // constants 
    final float s2 = size / 2;
    final float s6 = size / 6;
    final float sl = size * line;
    
    stroke(255);
    
    /* Front faces */
    
    // front left vertical
    line(-s2, s2, s6, -s2, s2 - sl, s6);
    line(-s2, -s2, -s6, -s2, -s2 + sl, -s6);
    
    // front left horizontal
    line(-s2, s6, -s2, -s2, s6, -s2 + sl);
    line(-s2, -s6, s2, -s2, -s6, s2 - sl);
    
    // front right vertical
    line(s6, s2, s2, s6, s2 - sl, s2);
    line(-s6, -s2, s2, -s6, -s2 + sl, s2);
    
    // front right horizontal
    line(s2, -s6, s2, s2 - sl, -s6, s2);
    line(-s2, s6, s2, -s2 + sl, s6, s2);
    
    // top vertical 
    line(s6, -s2, s2, s6, -s2, s2 - sl);
    line(-s6, -s2, -s2, -s6, -s2, -s2 + sl);
    
    // top horizontal
    line(s2, -s2, -s6, s2 - sl, -s2, -s6);
    line(-s2, -s2, s6, -s2 + sl, -s2, s6);
    
    /* Back faces */
    
    // back right vertical
    line(s2, s2, -s6, s2, s2 - sl, -s6);
    line(s2, -s2, s6, s2, -s2 + sl, s6);
    
    // back right horizontal
    line(s2, -s6, -s2, s2, -s6, -s2 + sl);
    line(s2, s6, s2, s2, s6, s2 - sl);
    
    // back left vertical
    line(-s6, s2, -s2, -s6, s2 - sl, -s2);
    line(s6, -s2, -s2, s6, -s2 + sl, -s2);
    
    // back left horizontal
    line(s2, s6, -s2, s2 - sl, s6, -s2);
    line(-s2, -s6, -s2, -s2 + sl, -s6, -s2);
    
    // bottom vertical
    line(-s6, s2, s2, -s6, s2, s2 - sl);
    line(s6, s2, -s2, s6, s2, -s2 + sl);
    
    // bottom horizontal
    line(s2, s2, s6, s2 - sl, s2, s6);
    line(-s2, s2, -s6, -s2 + sl, s2, -s6);
  }
  
  /** Split into 9 * 9 smaller cubes */
  private void splitBoxes() {    
    subBoxes = new Box[27];
    float subSize = size / 3;
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        for (int k = -1; k < 2; k++) {
          addSubBox(i, j, k, subSize);
        }
      }
    }
  }
  
  /** Split into 54 small triangles */
  private void splitTriangles() {
    subTris = new Triangle[54];
    // count
    int c = 0;
    // iterate through each column
    for (int i = 0; i < 6; i++) {
      
      // get # tris in column
      int n = int(12 - 2 * abs(2.5 - i));
      // get x position of RIGHT tris (change later for LEFT)
      float x = -SQ3 - oDSQ3 + (i * SQ3D2);
      // get y offset (centre columns need to be raised)
      float y = 1.5F + (i >= 3 ? (5 - i) : i) / 2F;
      
      // iterate over # tris
      for (int j = 0; j < n; j++) {
        
        if (j % 2 == 0 && i < 3 || j % 2 != 0 && i >= 3) {
          subTris[c] = new Triangle(triSize, x + 1F / 2F / SQ3, j / 2F - y, true);
        } else {
          subTris[c] = new Triangle(triSize, x, j / 2F - y, false);
        }
        
        c++; // increment count
      }
    }
  }
  
  /** Draw all sub boxes */
  private void drawSubBoxes() {    
    if (subBoxes == null) 
      splitBoxes();
      
    for (Box sub : subBoxes) {
      sub.drawAsSubBox();
    }
  }
  
  /** Draw all sub tris */
  private void drawSubTris() {
    unIso();
    if (subTris == null) 
      splitTriangles();
      
    for (Triangle tri : subTris) {
      tri.draw();
    }
  }
  
  /** Draw with opacity, zoom and spread */
  private void drawAsSubBox(){    
    if (zooming) zoom();
    if (spreading) spread();
    
    final float centreDist = dist(x, y, z, 0, 0, 0);
    final float opacityMult = min(1, (centreDist - size * 2) / 100F);
    // Don't draw if opacity should be 0
    if (opacityMult >= 1) return;
    stroke(255, 255 - floor(opacityMult * 255));
    
    translate(x, y, z);
    box(size);
    translate(-x, -y, -z);
  }
  
  /** Draw differently per stage */
  public void draw() {
    switch(stage) {
    case 0: 
      // draw box and lines
      animateLines();
      box(size);
      break;
      
    case 1:
    case 3: 
      // just draw sub boxes
      drawSubBoxes();
      break;
      
    case 2: 
      // just draw sub tris
      drawSubTris();
      break;
    }
  }
}

/** Triangle class */
public class Triangle {
  
  // attributes
  private float x, y;
  private float size;
  private final float initx, inity;
  private final float initialSize;
  private final boolean left;
  private float rotation;
  
  // counters [0, 1]
  private float spread;
  
  // flags
  public boolean spreading;
  
  /** Create a <size> triange at <x, y> facing left (true) or right (false)*/
  public Triangle(float size, float x, float y, boolean left) {
    this.initialSize = size;
    this.left = left;
    this.initx = x * size;
    this.inity = y * size;
  }
  
  private void spread() {
    if (spread >= 2 && stage == 2) {
      stage++;
      println("STAGE: " + stage);
    } else if (spread >= 2) {
      x = initx;
      y = inity;
      rotation = 0;
      size = initialSize;
    } else {
      spread += rate * 2;
      x = initx * (sinLerp(spread) / 4 + 1);
      y = inity * (sinLerp(spread) / 4 + 1);
      rotation = PI / 3F * sinLerp(spread / 2) * (left ? 1 : -1);
      size = initialSize * (1 - sinLerp(spread) / 4F);
    }
  }
  
  public void draw() {
    spread();
    
    translate(x, y);
    rotateZ(rotation);
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
    rotateZ(-rotation);
    translate(-x, -y);
  }
}
