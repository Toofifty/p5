/*------------------------------------------
  "Triterion"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

boolean scan = true;     // move?
boolean trixel = true;   // pixels or trixels?
boolean eq_tri = true;   // use equilaterial tris? (requires 'trixel')
boolean hexels = false;  // use hexels? (requires 'eq_tri')
boolean output = true;  // draw to png and quit?

float res = 10;           // resolution : inverse! 10 means less trixels than 5
int opac = 250;          // opacity of the triangles, 0-255

String out = "img";      // name of file output

float v_res;
float h_res;
float tr;
float S3 = sqrt(3);

PImage img;

void setup () {
  img = loadImage("img.jpg");
  size(img.width, img.height, P3D);
  v_res = height / res;
  h_res = width / res;
  smooth(8);
  frameRate(60);
  ortho();
  noStroke();
}

void draw () {
  image(img, 0, 0);
  filter(GRAY);
  for (int j = -2; j < v_res + 2; j++) {    // -2 and +2 to make sure we
    for (int i = -2; i < h_res + 2; i++) {  // fill the entire screen
      beginShape(TRIANGLES);
        makeTriangles(i, j);
      endShape();
    }
  }
  if (scan) tr += 1;
  else noLoop();
  if (tr > img.height / v_res) {
    tr -= img.height / v_res; 
  }
  if (output) {
    saveFrame("tri-" + out + ".png");
    exit();
  }
}

// square-based triangles
void makeTriangles (int i, int j) {
  if (eq_tri && trixel) {
    makeEqTriangles(i, j);
    return;
  }
  PVector p1 = new PVector(i * res + tr, j * res + tr);
  PVector p2 = new PVector(i * res + tr, (j+1) * res + tr);
  PVector p3 = new PVector((i+1) * res + tr, j * res + tr);
  PVector p4 = new PVector((i+1) * res + tr, (j+1) * res + tr);
  
  PVector c1 = findCentre(p1, p2, p4);
  PVector c2 = findCentre(p1, p3, p4);
  
  color col1 = color(img.get(int(c1.x), int(c1.y)), opac);
  color col2 = color(img.get(int(c2.x), int(c2.y)), opac);
  
  fill(col1);
  vvert(p1, red(col1));
  vvert(p2, red(col1));
  vvert(p4, red(col1));
  
  if (trixel) fill(col2);
  vvert(p1, red(col2));
  vvert(p3, red(col2));
  vvert(p4, red(col2));
}

// equilateral triangles
void makeEqTriangles (int i, int j) {
  float i_ = i;
  float j_ = float(j) * S3;
  PVector c = new PVector(i_ * res + tr, j_ * res + tr*S3);
  PVector p1;
  PVector p2;
  PVector p3;
  
  color col = color(img.get(int(c.x), int(c.y)), opac);
  
  fill(col);
  if (j % 2 == 0) {
    if (i % 2 == 0) { // This triangle ▲, first line
      p1 = new PVector(i_ * res + tr, (j_+0.5*S3) * res + tr*S3);
      p2 = new PVector((i_-1) * res + tr, (j_-0.5*S3) * res + tr*S3);
      p3 = new PVector((i_+1) * res + tr, (j_-0.5*S3) * res + tr*S3);
    } else {          // This triangle ▼, first line
      p1 = new PVector(i_ * res + tr, (j_-0.5*S3) * res + tr*S3);
      p2 = new PVector((i_-1) * res + tr, (j_+0.5*S3) * res + tr*S3);
      p3 = new PVector((i_+1) * res + tr, (j_+0.5*S3) * res + tr*S3);
    }
  } else {
    if (i % 2 != 0) { // This triangle ▼, second line
      p1 = new PVector(i_ * res + tr, (j_+0.5*S3) * res + tr*S3);
      p2 = new PVector((i_-1) * res + tr, (j_-0.5*S3) * res + tr*S3);
      p3 = new PVector((i_+1) * res + tr, (j_-0.5*S3) * res + tr*S3);
    } else {          // This triangle ▲, second line
      p1 = new PVector(i_ * res + tr, (j_-0.5*S3) * res + tr*S3);
      p2 = new PVector((i_-1) * res + tr, (j_+0.5*S3) * res + tr*S3);
      p3 = new PVector((i_+1) * res + tr, (j_+0.5*S3) * res + tr*S3);
    }
  }
  vvert(p1, red(col));
  vvert(p2, red(col));
  vvert(p3, red(col));
}

void vvert (PVector p, float z) {
  vertex(p.x, p.y, z);
}

PVector findCentre (PVector p1, PVector p2, PVector p3) {
  float x = (p1.x + p2.x + p3.x) / 3;
  float y = (p1.y + p2.y + p3.y) / 3;
  return new PVector(x, y);
}

