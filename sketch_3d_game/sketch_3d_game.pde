Player player;
Camera camera;
Map map;
final int GRID_SIZE = 32;

public void setup() {
  size(600, 600, P3D);
  background(32);
  strokeWeight(2);
  stroke(32);
  fill(255);
  camera = new Camera();
  player = new Player();
  map = new Map(50);
}

public void draw() {
  translate(width / 2, height / 2, 200);
  camera.applyRotate();
  background(32);
  rotateX(PI / 2);
  drawTerrain();
  player.draw();
}

public void drawTerrain() {
  noStroke();
  translate(GRID_SIZE / 2, GRID_SIZE / 2);
  player.translateView();
  map.draw();
  translate(-GRID_SIZE / 2, -GRID_SIZE / 2);
  player.translateBack();
}

public void mouseDragged() {
  camera.updateRotate(mouseX - pmouseX, mouseY - pmouseY);
}

public void keyPressed() {
  switch(key) {
  case 'w':
    player.moveN();
    break;
  case 'a':
    player.moveW();
    break;
  case 's':
    player.moveS();
    break;
  case 'd':
    player.moveE();
    break;
  default:
    println(key);
  }
}
