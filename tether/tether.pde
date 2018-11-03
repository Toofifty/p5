/* Tethered
  Grid of tethered objects (circles)
  Each object moves randomly, but is slightly attracted to it's original point.
  Each object is also slightly repelled by the cursor.
  Neighboring objects closer than their original distance will show a connection.
*/

int GRID_DIST = 100;
int OBJ_SIZE = 5;

// % of the time it would return to it's OP
float ATTRACT_RATE = 0.7;
// % of the time it would move away from the cursor
float REPEL_RATE = 0.2;

float MOVE_RATE = 0.05;

TObject[] objects;
PVector mouse = new PVector(0, 0);

public void setup() {
  size(1920, 1080);
  
  stroke(255);
  noFill();
  
  int xcount = int(width / GRID_DIST) + 1;
  int ycount = int(height / GRID_DIST) + 1;
  
  objects = new TObject[xcount * ycount];
  
  for (int i = 0; i < xcount; i++) {
    for (int j = 0; j < ycount; j++) {
        objects[j * xcount + i] = new TObject(i * GRID_DIST, j * GRID_DIST);
    }
  }
}

public void draw() {
  background(32);
  
  mouse.x = mouseX;
  mouse.y = mouseY;
  
  for (int i = 0; i < objects.length; i++) {
    objects[i].update();
    objects[i].draw(i);
  }
}

class TObject {
  
  PVector opos, pos, vel;
  
  public TObject(float x, float y) {
    opos = new PVector(x, y);
    pos = new PVector(x, y);
    vel = new PVector(random(-1, 1), random(-1, 1));
    vel.setMag(1);
  }
  
  public void update() {
    // mouse repel
    /*float d = max(5, pos.dist(mouse));
    float magn;
    PVector diff;
    if (d < 250) {
      magn = 3 / max(5, pos.dist(mouse));
      diff = pos.copy().sub(mouse);
      diff.mult(magn);
      pos.add(diff);
    }
    
    // OP attract
    magn = 2 / max(5, pos.dist(opos));
    diff = opos.copy().sub(pos);
    diff.mult(magn);
    pos.add(diff);*/
    
    // roll dice, decide to attract, repel or move randomly
    float r = random(1);
    PVector dvel;
    if (r < ATTRACT_RATE) {
      // attract to OP
      dvel = opos.copy().sub(pos);
      dvel.setMag(MOVE_RATE);
      vel.add(dvel);
      
    } else {
      // random movement
      dvel = new PVector(random(-1, 1), random(-1, 1));
      dvel.setMag(MOVE_RATE);
      vel.add(dvel);
    }
    
    float d = max(5, pos.dist(mouse));
    if (d < 150) {
      // repel from cursor
      dvel = pos.copy().sub(mouse);
      dvel.setMag(20 / d);
      vel.add(dvel);
    }
    
    if (vel.mag() > 2) {
      vel.setMag(2);
    }
    
    pos.add(vel);
  }
  
  public void draw(int n) {
    ellipse(pos.x, pos.y, OBJ_SIZE, OBJ_SIZE);
    for (int i = n + 1; i < objects.length; i++) {
      float d;
      if ((d = pos.dist(objects[i].pos)) < GRID_DIST) {
        stroke(255, 255, 255, 255 - (d / GRID_DIST) * 255);
        line(pos.x, pos.y, objects[i].pos.x, objects[i].pos.y);
        stroke(255);
      }
    }
  }
  
}