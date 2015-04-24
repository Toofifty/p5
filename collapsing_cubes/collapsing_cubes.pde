/*=======================

  Collapsing Cubes
  
  @author: Toofifty

  =====================*/
  
// CUSTOM VALUES
public final int BOX_SIZE = 100;
public final float RATE = 0.05F;    // speed of animation
public final color BG = color(255);

public Box mainBox;
public Box zExtrude;
public Box[] xExtrude = new Box[2];
public Box[] yExtrude = new Box[4];

public Panel[] panels = new Panel[9];

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

public void setup() {
  
  size(600, 600, P3D);
  ortho();
  fill(32);
  //noFill();
  strokeWeight(5);
  smooth(8);
  frameRate(30);
  stroke(255);
  
  mainBox = new Box(0, 0, 0);
  
}

public void draw() {
  
  background(BG);
  translate(width / 2, height / 2);
  
  iso();
  doRotate();
  
  mainBox.draw();
  
  if (stage == 0) extrude();
  if (stage == 2) panelise();
  
  if (zExtrude == null || stage > 1) return;
  zExtrude.draw();
  
  if (xExtrude[0] == null) return;
  
  xExtrude[0].draw();
  xExtrude[1].draw();
  
  if (yExtrude[0] == null) return;
  
  fill(64, 64, 127);
  yExtrude[0].draw();
  fill(32);
  yExtrude[1].draw();
  yExtrude[2].draw();
  yExtrude[3].draw();
}

public void panelise() {
  
  if (panels[0] == null) {
    
    panels[0] = new Panel(1, 1, 0, 2, PI / 2, PI / 2);
    panels[1] = new Panel(1, 0, -1, 1, -PI / 2, PI / 2);
    panels[2] = new Panel(0, 1, -1, 0, -PI / 2, PI / 2);
    // outer most
    panels[3] = new Panel(1, 1, 0, 0, 0, PI / 2);
    panels[4] = new Panel(0, 1, -1, 1, 0, PI / 2);
    panels[5] = new Panel(1, 0, -1, 2, 0, PI / 2);
    
    panels[6] = new Panel(0, 1, 0, 2, -PI / 2, -PI / 4);
    panels[7] = new Panel(1, 0, 0, 1, PI / 2, -PI / 4);
    panels[8] = new Panel(0, 0, -1, 0, PI / 2, -PI / 4);
    
  }
  
  int e;
  if (panels[0].rotCount < 1) {
    
    e = 3;
    
  } else if (panels[3].rotCount < 1) {
    
    e = 6;
    
  } else if (panels[6].rotCount < 1) {
    
    e = 9;
    
  } else {
    
    reset();
    return;
    
  }
  
  for (int i = 0; i < 9; i++) {
    
    if (i == 3) fill(64, 64, 127);
    else fill(32);
    
    if (i < e) panels[i].update();
    panels[i].draw();
    
  }
  
}

public void reset() {
  
  stage = 0;
  zExtrude = null;
  xExtrude = new Box[2];
  yExtrude = new Box[4];  
  panels = new Panel[9];
  
}

public void doRotate() {
  
  if (stage == 1 || stage == 3) {
    
    yRotate += RATE;
    
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
    
    extrude += RATE * 3;
    zExtrude.d = sinLerp(extrude) * BOX_SIZE / 2;
    
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
    
    extrude += RATE * 3;
    xExtrude[0].w = sinLerp(extrude) * BOX_SIZE / 2;
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
    
    extrude += RATE * 3;
    yExtrude[0].h = sinLerp(extrude) * BOX_SIZE / 2;
    yExtrude[3].h = yExtrude[2].h = yExtrude[1].h = yExtrude[0].h;
    
    if (extrude >= 1) {
    
      extrudeStage = 0;
      extrude = 0;
      stage++;
    
    }
    
    break;
    
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
  
  public float x, y, z;
  public float w, h, d;
  
  public Box(float x, float y, float z) {
    
    w = h = d = BOX_SIZE;
    this.x = (x - 0.5F) * BOX_SIZE;
    this.y = (y - 0.5F) * BOX_SIZE;
    this.z = (z + 0.5F) * BOX_SIZE;
    
  }
  
  public void setSize(float w, float h, float d) {
    
    this.w = w;
    this.h = h;
    this.d = d;
    
  }
  
  public void draw() {
    
    translate(x, y, z);
    translate((BOX_SIZE - w) / -2, (BOX_SIZE - h) / -2, (BOX_SIZE - d) / 2);
    box(w, h, d);
    translate((BOX_SIZE - w) / 2, (BOX_SIZE - h) / 2, (BOX_SIZE - d) / -2);
    translate(-x, -y, -z);
    
  }
}

public class Panel {
  
  public float x, y, z; // of hinge
  public float size;
  public float rotation;
  public float rotAmount;
  public int axis; // 0=x/y 1=z
  
  public float rotCount;
  
  public Panel(float x, float y, float z, int axis, float rotation, float rotAmount) {
    
    this.x = x * BOX_SIZE;
    this.y = y * BOX_SIZE;
    this.z = z * BOX_SIZE;
    this.size = BOX_SIZE;
    this.axis = axis;
    this.rotation = rotation;
    this.rotAmount = rotAmount;
    
  }
  
  public void update() {
    
    rotCount += RATE * 3;
    
  }
  
  public void draw() { 
    
    if (rotCount >= 1) return; 
    
    translate(x, y, z);
    switch(axis) {
      
    case 0: // x or y
      rotateY(rotation + sinLerp(rotCount) * rotAmount);
      rect(0, 0, size, size);
      rotateY(-rotation - sinLerp(rotCount) * rotAmount);
      break;
      
    case 1:
      rotateY(PI / 2);
      rotateX(rotation + sinLerp(rotCount) * rotAmount);
      rect(0, 0, size, size);
      rotateX(-rotation - sinLerp(rotCount) * rotAmount);
      rotateY(-PI / 2);
      break;
      
    case 2:
      rotateX(3 * PI / 2);
      rotateX(-rotation + sinLerp(rotCount) * rotAmount);
      rect(0, 0, size, size);
      rotateX(rotation - sinLerp(rotCount) * rotAmount);
      rotateX(-3 * PI / 2);
      break;
      
    }
    
    translate(-x, -y, -z);
    
  }
  
}
