/* string ball */

final float G = 9.8;
boolean grav = false;
boolean string = false;
float time = 0;

Ball ball;

void setup() {
  size(600, 600);
  fill(255);
  noStroke();
  frameRate(60);
  ball = new Ball(width/2, height/2);
  background(32);
}

void draw() {
  float dt = dt();
  background(32);
  //ball.physicsStep();
  ball.stringStep();
  ball.draw();
  stroke(0, 255, 255);
  line(mouseX, mouseY, ball.pos.x, ball.pos.y);
}

float dt() {
  float d = millis() - time;
  time = millis();
  return d;
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (ball.isCollide(mouseX, mouseY)) {
      ball.isHeld = true;
    }
  }
}

void mouseDragged() {
  if (mouseButton == LEFT) {    
    if (ball.isCollide(mouseX, mouseY)) {
      ball.addPos(mouseX - pmouseX, mouseY - pmouseY);
      ball.isHeld = true;
    } else {
      ball.isHeld = false;
    }
  }
}

void keyPressed() {
  if (key == 'g') grav = !grav;
  if (key == 's') string = !string;
}

void mouseReleased() {
  ball.isHeld = false;
}

class Ball {
  
  PVector pos;
  PVector vel;
  PVector acc;
  PVector a2c;
  int m = 50;
  boolean isHeld;
  
  float stringLength = 200;
  
  Ball(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, G / frameRate / 20);
  }
  
  void physicsStep() {
    if (isHeld || !grav) return;
    vel.x += acc.x;
    vel.y += acc.y;
    
    update();
  }
  
  void stringStep() {
    if (isHeld || !string) return;
    //stringLength = dist(pos.x, pos.y, mouseX, mouseY);
    a2c = accToCentre();
    vel.x += acc.x + a2c.x;
    vel.y += acc.y + a2c.y;
    
    update();
  }
  
  void update() {
    pos.x += vel.x;
    pos.y += vel.y;
    
    pos.x %= width;
    
    if (pos.y + m / 2 >= height) {
      pos.y = height - m / 2;
      vel.y = 0;
    }
  }
  
  PVector accToCentre() {
    float mag = vel.magSq() / stringLength * 2;
    PVector a = PVector.fromAngle(lineAngle());
    a.mult(mag);
    return a;
  }
  
  PVector F() {
    PVector f = acc.get();
    f.mult(m);
    return f;
  }
  
  float lineAngle() {
    if (pos.x < mouseX) {
      return atan((pos.y - mouseY) / (pos.x - mouseX));
    } else {
      return PI + atan((pos.y - mouseY) / (pos.x - mouseX));
    }
  }
  
  void addPos(float x, float y) {
    pos.x += x;
    pos.y += y;
  }
  
  boolean isCollide(float x, float y) {
    return dist(x, y, pos.x, pos.y) <= m/2;
  }
  
  void draw() {
    a2c = accToCentre();
    noStroke();
    ellipse(pos.x, pos.y, m, m);
    translate(pos.x, pos.y);
    strokeWeight(4);
    stroke(255, 0, 0);
    line(0, 0, a2c.x * 100, a2c.y * 100);
    stroke(0, 255, 0);
    line(0, 0, acc.x * 100, acc.y * 100);
    strokeWeight(1);
    translate(-pos.x, -pos.y);
  }
  
}
