/* starfield */

Particle[] particles = new Particle[2048];
float zbegin = -1000;
float zcutoff = 1000;
float speed = 5;
float moveSpeed = 2;

void setup() {
  size(500, 500, P3D);
  noStroke();
  fill(255);
  background(32);
  frameRate(120);
  colorMode(HSB, 255);
  
  for (int i = 0; i < particles.length; i++) {
    particles[i] = randParticle();
  }
}

void draw() {
  translate(0, 0, zbegin);
  fill(32, 64);
  rect(-5000, -5000, 10000, 10000);
  translate(0, 0, -zbegin);
  fill(255);
  translate(width / 2, height / 2);
  //background(32);
  for (Particle p : particles) {
    if (p != null) {
      if (!p.moving && random(1) > 0.99F) {
        p.start();
      }
      if (p.isOffscreen()) {
        p.setPos(random(-1000, 1000), random(-1000, 1000));
      }
      p.update();
      p.draw();
    }
  }
}

Particle randParticle() {
  return new Particle(random(-1000, 1000), random(-1000, 1000));
}

class Particle {
  
  PVector pos;
  boolean moving = false;
  
  Particle(float x, float y) {
    setPos(x, y);
  }
  
  void setPos(float x, float y) {
    float sx = screenX(x, y, zcutoff);
    float sy = screenY(x, y, zcutoff);
    pos = new PVector(x, y, zbegin);
    if (!isOffscreen(sx, sy, zcutoff)) {
      //setPos(random(-1000, 1000), random(-1000, 1000));
    }
  }
  
  boolean isOffscreen() {
    float sx = screenX(pos.x, pos.y, pos.z);
    float sy = screenY(pos.x, pos.y, pos.z);
    return isOffscreen(sx, sy, zcutoff);
  }
  
  boolean isOffscreen(float sx, float sy, float z) {
    return sx > width || sx < 0
      || sy > height || sy < 0
      || pos.z > z || pos.z < zbegin;
  }
  
  void start() {
    moving = true;
  }
  
  void update() {
    if (!moving) return;
    pos.z += speed;
  }
  
  void draw() {
    if (!moving) return;
    fill((pos.z + 1000) / 1000 * 255, 128, 255, (pos.z + 1000) / 1000 * 255 + 32);
    translate(pos.x, pos.y, pos.z);
    ellipse(0, 0, 2, 2);
    translate(-pos.x, -pos.y, -pos.z);
  }
  
}

void keyPressed() {
  
  boolean up = false, 
    right = false, 
    down = false, 
    left = false;
  
  switch(keyCode) {
  case 38:
    up = true;
    break;
  case 39:
    right = true;
    break;
  case 40:
    down = true;
    break;
  case 37:
    left = true;
    break;
  }
  
  for (Particle p : particles) {
    if (up) p.pos.y += moveSpeed;
    if (down) p.pos.y -= moveSpeed;
    if (left) p.pos.x += moveSpeed;
    if (right) p.pos.x -= moveSpeed;
  }
  
}
