/*------------------------------------------
  "Field of Creation (website)"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

int numPointsX = 50;
int numPointsY = 50;
float maxDistance = 100;

float rx = 0;
float ry = 0;
float dx = 0;
float dy = 100;
float dz = 0;

Point[] pointField = new Point[numPointsX * numPointsY];
Marker[] markers = new Marker[3];

void setup () {
  size(1920, 1080, P3D);
  
  stroke(200);
  noFill();
  smooth(8);
  
  for (int i = 0; i < numPointsX; i++) {
    for (int j = 0; j < numPointsY; j++) {
      pointField[i * numPointsX + j] = new Point(i*100 + random(-10, 10), j*100 + random(-10, 10));
    }
  }
  
  markers[0] = new Marker(1000, 1000, 1000);
  markers[1] = new Marker(4000, 2000, 1000);
  markers[2] = new Marker(2000, 2400, 1000);
}

void draw () {
  // constrain all variables
  rx = min(-0.2, rx);
  rx = max(-1, rx);
  dy = constrain(dy, 100, 1000);
  
  translate(width/2, height/2);
  //translate(dx, dy, dz);
  doRotate(true);
  background(32);
  
  fill(255, 0, 0);
  int n = 0;
  for (Point p : pointField) {
    float d = dist(p.sX(), p.sY(), mouseX, mouseY);
    p.calcMarkerHeight();
    //p.addHeight(100 * noise(p.x, p.y + float(frameCount) / 100));
    if (d < 100) {
      p.addHeight(100-d);
    } else {
      p.addHeight(0);
    }   
    p.draw();
    noFill();
    n++;
  }
  
  beginShape(TRIANGLES);
  for (int i = 0; i < pointField.length; i++) {
    if (i % numPointsX != 0) drawTriangle(1, i);
    if (i != numPointsX - 1) drawTriangle(2, i);
  }
  endShape();
  
  for (Point p : pointField) {
    p.setHeight(0);
  }
  
  for (Marker m : markers) {
    m.draw();
  }
}

void drawTriangle (int type, int i) {
  try {
    pointField[i].drawVertex();
    switch(type) {
    case 1: // back
      if (i == numPointsX + 1) break;
      pointField[i - 1].drawVertex();
      pointField[i + numPointsX].drawVertex();
      break;
    case 2: // forward
      pointField[i + numPointsX].drawVertex();
      pointField[i + numPointsX + 1].drawVertex();
      break;
    }  
  } catch (ArrayIndexOutOfBoundsException e) {
    
  }
}

void keyPressed () {
  float f = 0.1;
  switch(key) {
  case 'i': 
    rx += f;
    break;
  case 'k': 
    rx -= f;
    break;
  case 'j': 
    ry += f;
    break;
  case 'l': 
    ry -= f;
    break;
  case 'w': 
    dx += 10*f;
    break;
  case 's': 
    dx -= 10*f;
    break;
  case 'a': 
    dz += 10*f;
    break;
  case 'd': 
    dz -= 10*f;
    break;
  }
}

void mouseDragged () {
  if (mouseButton == LEFT) {
    dx += mouseX - pmouseX;
    dy += mouseY - pmouseY;
  } else if (mouseButton == RIGHT) {
    ry += float(mouseX - pmouseX) / 200;
    rx -= float(mouseY - pmouseY) / 800;
  }
}

void mouseWheel (MouseEvent event) {
  float c = event.getCount();
  dz -= c * 100;
  //dx += c * cos(rx);
  //dy += c * sin(rx);
  
}

void doRotate (boolean rev) {
  if (rev) {
    rotateX(rx);
    rotateY(ry);
  } else {
    rotateY(-ry);
    rotateX(-rx);
  }
}

class Point {
  float x, y, z;
  
  public Point (float x, float z) {
    this.x = x;
    this.y = 0;
    this.z = z;
  }
  
  public void addHeight (float y) {
    this.y += y;
  }
  
  public void setHeight (float y) {
    this.y = y;
  }
  
  public void calcMarkerHeight () {
    for (int i = 0; i < markers.length; i++) {
      float d = dist(x, 0, z, markers[i].x, 0, markers[i].z);
      float r = markers[i].r;
      if (d < r) {
        float c = r - d;
        //this.addHeight(1 * sqrt(c));
        this.addHeight(40 * sin((c+float(frameCount)) /r * TWO_PI * 2));
      }
    }
  }
  
  public float sX () {
    return screenX(x, y, z);
  }
  
  public float sY() {
    return screenY(x, y, z);
  }
  
  public void draw () {
    translate(x, y, z);
    doRotate(false);
    ellipse(0, 0, 10, 10);
    doRotate(true);
    translate(-x, -y, -z);
  }
  
  public void drawVertex () {
    vertex(x, y, z);
  }
}

class Marker {
  float x, z, r;
  float y = -100;
  
  public Marker (float x, float z, float r) {
    this.x = x;
    this.z = z;
    this.r = r;
  }
  
  public void draw () {
    translate(x, y, z);
    doRotate(false);
    fill(32);
    ellipse(0, 0, 100, 100);
    noFill();
    doRotate(true);
    translate(-x, -y, -z);
  }
}
