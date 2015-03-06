public float x, y, x2, y2;

public void setup() {
  size(800, 800);
  background(32);
}

public void draw() {
  //background(32);
  if (x2 != 0) {
    fill(random(255), random(255), random(255));
    rect(x, y, x2 - x, y2 - y);
  }
}

public void mousePressed() {
  if (x == 0) {
    x = mouseX;
    y = mouseY;
  } else if (x2 == 0) {
    x2 = mouseX;
    y2 = mouseY;
  } else {
    x = y = x2 = y2 = 0;
  }
}

public void mouseDragged() {
  if (x == 0) {
    x = mouseX;
    y = mouseY;
  } else {
    x2 = mouseX;
    y2 = mouseY;
  }
}
