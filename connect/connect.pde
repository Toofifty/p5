/*
 * Cursor controlled background
*/

int vertCount = 40;
float vertSize = 30;
float edgeSize = 2;
float moveFactor = 20f;
float maxDistance = 200f;
float speed = 0.5f;

float _mx;
float _my;
float _pmx;
float _pmy;

boolean _md = false;

boolean web = false;

float maxWidth;
float maxHeight;
float minWidth;
float minHeight;

float[] bg = new float[]{4, 29, 55};
float[] fg = new float[]{115, 140, 166};

Vertex[] vertices = new Vertex[vertCount];

void setup () {
  // Screen setup
  size(1920, 1080);
  frameRate(60);
  
  minWidth = -width / moveFactor;
  minHeight = -height / moveFactor;
  maxWidth = width - minWidth;
  maxHeight = height - minHeight;
  // Vertex setup
  for (int i = 0; i < vertCount; i++) {
    vertices[i] = new Vertex();
  }
  
  strokeWeight(edgeSize);
  textSize(32);
}

void draw () {
  background(bg[0], bg[1], bg[2]);
  for (int i = 0; i < vertCount; i++) {
    vertices[i].move();
    vertices[i].movespace();
    vertices[i].drawlines(i);
    vertices[i].draw();
  }
  for (int i = 0; i < vertCount; i++) {
    if (vertices[i].checkbounds()) {
      if (!mousedown()) continue;
      vertices[i].drag();
    }
  }
}

float dis(float x1, float y1, float x2, float y2) {
  return sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
} 

void setmouse (float mx, float my) {
  _pmx = _mx;
  _pmy = _my;
  _mx = mx;
  _my = my;
}

boolean mousedown () {
  if (web) return _md;
  return mousePressed;
}

void omd () {
  _md = true;
}

void omu () {
  _md = false;
}

float mx () {
  if (web) return _mx;
  return mouseX;
}

float my () {
  if (web) return _my;
  return mouseY;
}

float pmx () {
  if (web) return _pmx;
  return pmouseX;
}

float pmy () {
  if (web) return _pmy;
  return pmouseY;
}

class Vertex {
  float _x;
  float _y;
  float _dir;
  int _m = 1;
  boolean _d;
  float _v;
  
  public Vertex (float x, float y) {
    _x = x;
    _y = y;
    _dir = random(0, 360);
    _v = random(-vertSize/10, vertSize/10);
  }
  
  public Vertex () {
    _x = random(0, maxWidth);
    _y = random(0, maxHeight);
    _dir = random(0, 360);
    _v = random(-vertSize+1, vertSize);
  }
  
  public void move () {
    if (_d) return;
    float _mdir = atan((my() - _y) / (mx() - _x));
    
    _x += speed * cos(_dir);
    _y += speed * sin(_dir);
    
    _x += speed * cos(_mdir);
    _y += speed * sin(_mdir);
    
    _dir += _m * speed / 50f;
    
    if (random(0, 100) > 98) {
      _m *= -1;
    }
    
    while (_dir > 360) {
      _dir -= 360;
    }
    while (_dir < 0) {
      _dir += 360;
    }
    
    while (_x > maxWidth) {
      _x -= maxWidth;
    } 
    while (_x < minWidth) {
      _x += maxWidth;
    } 
    while (_y > maxHeight) {
      _y -= maxHeight;
    } 
    while (_y < minHeight) {
      _y += maxHeight;
    }
  }
  
  public void movespace () {
    if (_d) return;
    float dx = mx() - pmx();
    float dy = my() - pmy();
    
    _x -= dx/moveFactor;
    _y -= dy/moveFactor;
  }
  
  public boolean checkbounds () {
    if (dis(_x, _y, mx(), my()) <= vertSize) {
      _d = true;
    } else {
      _d = false;
    }
    return _d;
  }
  
  public void drag () {
    _x = mx();
    _y = my();
  }
  
  public void drawlines (int start) {
    for (int i = start; i < vertCount; i++) {
      float distance = dis(_x, _y, vertices[i]._x, vertices[i]._y);
      if (distance < maxDistance) {
        stroke(fg[0], fg[1], fg[2], 255 - (255 * distance / maxDistance));
        line(_x, _y, vertices[i]._x, vertices[i]._y);
      }
    }
  }
  
  public void draw () {
    float _mdis = dis(_x, _y, mx(), my());
    stroke(fg[0], fg[1], fg[2], 255 - _mdis * 255 / width);
    fill(fg[0], fg[1], fg[2], 255 - _mdis * 255 / 500);
    if (_d) {
      ellipse(_x, _y, (_v + vertSize) * 1.2f, (_v + vertSize) * 1.2f);
      return;
    }
    ellipse(_x, _y, _v + vertSize, _v + vertSize);
  }
}
