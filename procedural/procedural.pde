/* --- SETTINGS --- */

/* SETTINGS - GRAPHICS */

  // Game size should be a power of
  // 2 to ensure the pixel shader
  // works properly.
  final int GAME_SIZE = 1024;
  
  // Screen will have 2^PIXEL_SCALE pixels
  // in height/width
  final int PIXEL_SCALE = 8;
  
  // Color of the linear fog
  final color FOG_COLOR = color(142, 176, 255);
  
  // Color of the sky
  final color SKY_COLOR = FOG_COLOR;

/* SETTINGS - GAME */

/* SETTINGS - WORLD */

  final int MAP_SIZE = 64;
  final int TILE_SIZE = 128;

/* --- END SETTINGS --- */

/* GLOBALS */

  /// Camera

  // Camera rotations
  float rx, ry, rz;
  // Ship rotations
  float srx, sry, srz;
  
  // Camera position offsets
  float cx, cy, cz;
  
  // Movement directions
  // forward, left, up
  int mForward = 1, mLeft, mUp;
  
  /// Graphics
  
  // Pixel shader
  PShader pxShader;
  
  // Font
  PFont visitor;
  
  /// Game

/* END GLOBALS */

void setup() {
  
  size(GAME_SIZE, GAME_SIZE, P3D);
  noStroke();
  smooth(0);
  fill(255);
  textSize(32);
  //ortho();
  
  pxShader = loadShader("frag.glsl");
  pxShader.set("size", pow(2, PIXEL_SCALE));
  
  visitor = loadFont("visitor.vlw");
  textFont(visitor);
  
}

void draw() {
  
  background(SKY_COLOR);
  
  cx += 50 * -mForward * sin(ry);
  cz += 50 *  mForward * cos(ry);
  
  ry -= rz / 10.0;
  
  rz += mLeft / 50.0;
  
  rz = constrain(rz, -HALF_PI / 2, HALF_PI / 2);
  
  if (mLeft == 0) {
    rz /= 1.08;
  }
  
  sry += (ry - sry) / 4;
  //srz += (rz - srz) / 4;
  
  //cy = terrainVertex(MAP_SIZE / 2, MAP_SIZE / 2).y;
  
  translate(width / 2, height / 2, 500);
  
  rotateZ(rz);
  rotateX(rx);
  rotateY(ry);
  
  translate(cx - MAP_SIZE * TILE_SIZE / 2, 800 - cy, cz - MAP_SIZE * TILE_SIZE / 2);
  
  //translate(cx - MAP_SIZE * TILE_SIZE / 2, cy + 1300, cz - MAP_SIZE * TILE_SIZE / 2);
  
  lights();
  
  drawTerrainMesh();
  
  drawWaterMesh();
  
  //translate(-cx + MAP_SIZE * TILE_SIZE / 2, -cy - 1300, -cz + MAP_SIZE * TILE_SIZE / 2);
  
  translate(-cx + MAP_SIZE * TILE_SIZE / 2, -800 + cy, -cz + MAP_SIZE * TILE_SIZE / 2);
  
  fill(255, 0, 0);
  box(20);
  
  noLights();
  
  drawShip();
  drawFog();
  
  rotateY(-ry);
  rotateX(-rx);
  rotateZ(-rz + (sry - ry) / 4);
  
  translate(-width / 2, -height / 2);
  
  fill(255);
  text(int(frameRate) + "FPS", 50, 80);
  
  filter(pxShader);
  
}

/* Processing methods */

void mouseDragged() {
  
  //ry += (float) (mouseX - pmouseX) / 100;
  rx -= (float) (mouseY - pmouseY) / 100;
  
}

void keyPressed() {
  
  switch(key) {
  case 'w':
    mForward = 1;
    break;
  case 's':
    mForward = -1;
    break;
  case 'a':
    mLeft = 1;
    break;
  case 'd':
    mLeft = -1;
    break;
  default:
    println(key);
  }
  
}

void keyReleased() {
  
  if (key == 'w' || key == 's') {
    
    mForward = 0;
    
  } else if (key == 'a' || key == 'd') {
    
    mLeft = 0;
    
  }
  
}

/* Custom methods */

void drawTerrainMesh() {
  
  beginShape(TRIANGLES);
  
  for (int i = 0; i < MAP_SIZE; i++) {
    for (int j = 0; j < MAP_SIZE; j++) {
        
      terrainTri(
        terrainVertex(i, j),
        terrainVertex(i + 1, j),
        terrainVertex(i, j + 1)
      );
      
      terrainTri(
        terrainVertex(i + 1, j),
        terrainVertex(i, j + 1),
        terrainVertex(i + 1, j + 1)
      );
      
    }
  }
  
  endShape();
  
}

void drawWaterMesh() {
  
  beginShape(TRIANGLES);
  
  for (int i = 0; i < MAP_SIZE; i++) {
    for (int j = 0; j < MAP_SIZE; j++) {
      
      waterTri(
        waterVertex(i, j),
        waterVertex(i + 1, j),
        waterVertex(i, j + 1)
      );
      
      waterTri(
        waterVertex(i + 1, j),
        waterVertex(i, j + 1),
        waterVertex(i + 1, j + 1)
      );
      
    }
  }
  
  endShape();
  
}

PVector terrainVertex(int i, int j) {
  
  int xOffset = (int) cx / TILE_SIZE;
  int zOffset = (int) cz / TILE_SIZE;
  
  if (zOffset % 2 != 0) {
    zOffset -= 1;
  }
  
  i -= xOffset;
  j -= zOffset;
  
  return new PVector(
    i * TILE_SIZE, // x
    terrainNoise(i, j), // y
    j * TILE_SIZE  // z
  );
  
}

float terrainNoise(int i, int j) {
  float v = -noise(i / 10.0, j / 10.0) * 1200;
  v *= 2 * noise((i - 1000) / 10.0, j / 10.0);
  //v -= pow(noise((i + 1000) / 100.0, j / 100.0), 8) * 20000;
  return v;
}

void terrainTri(PVector p1, PVector p2, PVector p3) {
  
  float val = max(p1.y, max(p2.y, p3.y));
  fill(400 - p1.y / 2);
  if (val < -800) {
    fill(255);
  } else if (val < -700) {
    fill(128);
  } else if (val < -450) {
    fill(32, 192, 64);
  } else if (val < -400) {
    fill(107, 63, 44);
  } else {
    fill(255, 242, 150);
  }
  vertex(p1.x, p1.y, p1.z);
  vertex(p2.x, p2.y, p2.z);
  vertex(p3.x, p3.y, p3.z);
  
}

PVector waterVertex(int i, int j) {
  
  int xOffset = (int) cx / TILE_SIZE;
  int zOffset = (int) cz / TILE_SIZE;
  
  if (zOffset % 2 != 0) {
    zOffset -= 1;
  }
  
  i -= xOffset;
  j -= zOffset;
  
  return new PVector(
    i * TILE_SIZE, // x
    -noise((i + frameCount / 6.0) / 10.0, (j + frameCount / 5.0) / 10.0) * 100 - 300, // y
    j * TILE_SIZE  // z
  );
  
}

void waterTri(PVector p1, PVector p2, PVector p3) {
  
  fill(450 + p1.y, 400 + p1.y, 255, 192);
  vertex(p1.x, p1.y, p1.z);
  vertex(p2.x, p2.y, p2.z);
  vertex(p3.x, p3.y, p3.z);
  
}

void drawFog() {
  
  fill(FOG_COLOR, 255);
  sphere(4000);
  fill(FOG_COLOR, 128);
  sphere(3800);
  
}

void drawShip() {
  
  rotateZ(-srz);
  rotateY(-sry + HALF_PI);
  rotateX(-srx);
  
  fill(255);
  
  scale(2);
  
  beginShape();
  vertex(-5, 5, 5);
  vertex(-5, 5, -5);
  vertex(30, 2, -2);
  vertex(30, 2, 2);
  endShape(CLOSE);
  beginShape();
  vertex(-5, -5, 5);
  vertex(-5, -5, -5);
  vertex(30, -2, -2);
  vertex(30, -2, 2);
  endShape(CLOSE);
  beginShape();
  vertex(30, -2, -2);
  vertex(30, -2, 2);
  vertex(30, 2, 2);
  vertex(30, 2, -2);
  endShape(CLOSE);
  beginShape();
  vertex(-5, -5, 5);
  vertex(-5, 5, 5);
  vertex(30, 2, 2);
  vertex(30, -2, 2);
  endShape(CLOSE);
  beginShape();
  vertex(-5, -5, -5);
  vertex(-5, 5, -5);
  vertex(30, 2, -2);
  vertex(30, -2, -2);
  endShape(CLOSE);
  sphere(6);
  beginShape();
  vertex(-5, -5, -5);
  vertex(-5, 5, -5);
  vertex(30, 2, -2);
  vertex(30, -2, -2);
  endShape(CLOSE);
  
  scale(0.5);
  
  rotateX(srx);
  rotateY(sry - HALF_PI);
  rotateZ(srz);
  
}
