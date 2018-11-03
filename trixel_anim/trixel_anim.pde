/*------------------------------------------
  "Trixel Folder"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

PImage img;
float scale = 200;
float maxscale = 200;

float S3 = sqrt(3);

void setup () {
  img = loadImage("img.jpg");
  size(1000, 1000, P3D);
  smooth(8);
  frameRate(60);
  //stroke(255);
  noStroke();
  background(32);
  
  //image(img, 0, 0);
  filter(GRAY);
}

void draw () {
  for (int i = 0; i < 1000 / scale; i++) {
    beginShape();
    makeTriangle(int(random(img.width)), int(random(img.height)));
    endShape(CLOSE);
  }
  scale = random(8,maxscale);
  maxscale -= 1;
}

void makeTriangle (int i, int j) {
  float i_ = i;
  float j_ = float(j);
  PVector c = new PVector(i_, j_);
  PVector p1;
  PVector p2;
  PVector p3;
  
  color col = getColor(c);
  
  fill(col);
  if (i % 2 == 0) { // This triangle ▲, first line
    p1 = new PVector(i_, (j_+0.5*S3 * scale));
    p2 = new PVector((i_-1 * scale), (j_-0.5*S3 * scale));
    p3 = new PVector((i_+1 * scale), (j_-0.5*S3 * scale));
  } else {          // This triangle ▼, first line
    p1 = new PVector(i_, (j_-0.5*S3 * scale));
    p2 = new PVector((i_-1 * scale), (j_+0.5*S3 * scale));
    p3 = new PVector((i_+1 * scale), (j_+0.5*S3 * scale));
  }
  vvert(p1, red(col));
  vvert(p2, red(col));
  vvert(p3, red(col));
}

void vvert (PVector p, float z) {
  vertex(p.x, p.y);
}

color getColor (PVector p) {
  return color(img.get(int(p.x), int(p.y)), int(random(128)));
}