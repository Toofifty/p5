/* super hexagon in processing */

import java.util.List;

float baseRotation = 0;
int sides = 6;
float centreToCorner;
float timeSinceWave = 0;
float speed = 3;
float rotationSpeed = 2;
float antiSkew = 8;
float barWidth = 25;
float waveSep = 1;
color c1 = color(80);
color c2 = color(128);

float rotx = 0;
float roty = 0;

Player player;
Background background;

List<Obstacle> obs = new ArrayList<Obstacle>();
List<Obstacle> deadObs = new ArrayList<Obstacle>();

void setup() {
  
  size(500, 500, P3D);
  colorMode(HSB, 255);
  noStroke();
  player = new Player();
  background = new Background(c1, c2);
  centreToCorner = dist(0, 0, width, height);

  frameRate(60);
  
}

void draw() {
  
  baseRotation += rotationSpeed / frameRate;
  baseRotation %= TWO_PI;
  
  rotx += random(1) / frameRate;
  roty += random(1) / frameRate;
  
  translate(width / 2, height / 2);
  rotate(baseRotation);
  rotateX(sin(rotx) / antiSkew);
  rotateY(cos(roty) / antiSkew);
  background.draw();
  
  translate(0, 0, 1);
  
  for (Obstacle o : obs) {
    
    o.update();
    o.draw();
    
    if (o.dist <= 0) {
      
      deadObs.add(o);
      
    }
    
  }
  
  for (Obstacle o : deadObs) {
    
    obs.remove(o);
    
  }
  
  deadObs.clear();
  
  player.update();
  player.draw();
  
  drawCentre();
  
  rotateY(-sin(roty) / antiSkew);
  rotateX(-cos(rotx) / antiSkew);
  
  rotate(-baseRotation);
  translate(-width / 2, -height / 2);
  
  fill(255);
  textSize(12);
  text(round(frameRate), 10, 10);
  
  timeSinceWave += 1 / frameRate;
  
  if (timeSinceWave >= waveSep) {
    
    timeSinceWave = 0;
    
    addObstacle();
  
    if (random(1) >= 0.9) {
      
      rotationSpeed *= -1;
      
    } else if (random(1) >= 0.9) {
      
      rotationSpeed *= -1.3;
      
    } else if (random(1) >= 0.9) {
      
      rotationSpeed /= -1.3;
      
    }
    
    background.cswitch = !background.cswitch;
    
  }
  
}

void keyPressed() {
  
  if (keyCode == 39) {
    
    player.move(1);
    
  } else if (keyCode == 37) {
    
    player.move(-1);
    
  }
  
}

void keyReleased() {
  
  if (keyCode == 37 || keyCode == 39) {
    
    player.move(0);
    
  }
  
}

void addObstacle() {
  
 float init = random(1);
 float side = ceil(random(sides));

 if (init >= 0.9) {
   // 10% chance
   float opps = side + sides / 2;
   
   obs.add(new Obstacle(side + 1));
   obs.add(new Obstacle(opps + 1));
   
   for (int i = 0; i < sides; i++) {
     
     obs.add(new Obstacle(side + i, i * barWidth));
     obs.add(new Obstacle(opps + i, i * barWidth));
     
   }
   
   
 } else if (init >= 0.75) {
   // 15% chance
   obs.add(new Obstacle(side));
   
 } else if (init >= 0.55) {
   // 20% chance
   obs.add(new Obstacle(side));
   obs.add(new Obstacle(side + sides / 3));
   obs.add(new Obstacle(side + 2 * sides / 3));
   
 } else if (init >= 0.30) {
   // 25% chance
   obs.add(new Obstacle(side++));
   obs.add(new Obstacle(side++));
   obs.add(new Obstacle(side++));
   obs.add(new Obstacle(side++));
   obs.add(new Obstacle(side));
   
 } else {
   // 30% chance
   obs.add(new Obstacle(side));
   obs.add(new Obstacle(side + sides / 2));
   
 }
  
}

void drawCentre() {
  
  fill(255);
  
  beginShape();
  {
    
    for (int i = 0; i < sides; i++) {
      
      PVector vert = PVector.fromAngle((float) i / sides * TWO_PI);
      vert.mult(40);
      vertex(vert.x, vert.y);
      
    }
    
  }
  endShape(CLOSE);
  
  fill(c1);
  translate(0, 0, 1);
  
  beginShape();
  {
    
    for (int i = 0; i < sides; i++) {
      
      PVector vert = PVector.fromAngle((float) i / sides * TWO_PI);
      vert.mult(36);
      vertex(vert.x, vert.y);
      
    }
    
  }
  endShape(CLOSE);
  
  translate(0, 0, -1);
  
  noStroke();
  
}

class Obstacle {
  
  // distance to centre
  float dist;
  int sector;
  
  Obstacle(int sector, float offset) {
    
    this.sector = sector;
    this.dist = 500 + offset;
    
  }
  
  Obstacle(float approxSector) {
    
    this(int(approxSector), 0);
    
  }
  
  Obstacle(float approxSector, float offset) {
    
    this(int(approxSector), offset);
    
  }
  
  void update() {
    
    dist -= speed;
    
  }
  
  void draw() {
    
    if (dist <= 0) return;
    
    float startAngle = (float) sector / sides * TWO_PI;
    float endAngle = (float) (sector + 1) / sides * TWO_PI;
    
    PVector start = PVector.fromAngle(startAngle);
    PVector end = PVector.fromAngle(endAngle);
    
    PVector r1 = start.get();
    r1.mult(dist);
    PVector r2 = start.get();
    r2.mult(dist + barWidth);    
    PVector r3 = end.get();
    r3.mult(dist + barWidth);
    PVector r4 = end.get();
    r4.mult(dist);
    
    fill(255);
    quad(r1.x, r1.y, r2.x, r2.y, r3.x, r3.y, r4.x, r4.y);
    
  }
  
}

class Background {
  
  color color1;
  color color2;
  boolean cswitch = false;
  
  Background(color c1, color c2) {
    
    color1 = c1;
    color2 = c2;
    
  }
  
  void drawSector(int n) {
    
    float startAngle = (float) n / sides * TWO_PI;
    float endAngle = (float) (n + 1) / sides * TWO_PI;
    
    fill(n % 2 == 0 ^ cswitch ? color1 : color2);
    
    beginShape();
    {
      PVector vert1 = PVector.fromAngle(startAngle);
      PVector vert2 = PVector.fromAngle(endAngle);
      vert1.mult(centreToCorner);
      vert2.mult(centreToCorner);
      vertex(0, 0);
      vertex(vert1.x, vert1.y);
      vertex(vert2.x, vert2.y);
    }
    endShape(CLOSE);
    
    
  }
  
  void draw() {
    
    for (int i = 0; i < sides; i++) {
      drawSector(i);
    }
    
  }
  
}

class Player {
  
  float angle = 0;
  
  float radius = 50;
  
  int dir = 0;
  
  float da = 0;
  
  float size = 5.5;
  
  float x() {
    
    return radius * cos(angle);
    
  }  
  
  float y() {
    
    return radius * sin(angle);
    
  }
  
  void move(int dir) {
    
    this.dir = dir;
    
  }  
  
  void update() {
    
    da += dir / frameRate * 2;
    da = constrain(da, -0.15, 0.15);
    angle += da;
    
    angle %= TWO_PI;
    
    if (dir == 0) {
      da *= 0.5F;
    }
    
  }
  
  void draw() {
    
    fill(255);
    translate(x(), y());
    rotate(angle - HALF_PI);
    triangle(-size, 0, size, 0, 0, sqrt(3) * size);
    rotate(-angle + HALF_PI);
    translate(-x(), -y());
    
  }
  
}
