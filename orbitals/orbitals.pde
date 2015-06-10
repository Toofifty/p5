/* Orbitals */

PGraphics pix;

void setup() {
  size(512, 512);
  background(53, 43, 49);
  pix = createGraphics(width / 16, height / 16);
  
  pix.beginDraw();
  pix.background(53, 43, 49); 
  pix.smooth(0);
  pix.fill(255);
  pix.noStroke();
  pix.endDraw();
  
}

void draw() {
  int x = int(sin(frameCount / 60) * 16);
  int y = int(cos(frameCount / 60) * 16);
  PImage p = pix.get();
  image(nn(p, 16), 0, 0, width, height);
  pix.beginDraw();
  pix.background(53, 43, 49);  
  pix.ellipse(height / 32 + x, width / 32 + y, 16, 16);
  pix.endDraw();
}

PImage nn(PImage im, float sc) {  
  PImage o = createImage(int(sc * im.width), int(sc * im.height), RGB);
  im.loadPixels();
  o.loadPixels();
  for (int i = 0; i < o.width; i++) {
    for (int j = 0; j < o.height; j++) {
      int x = int(i / sc);
      int y = int(j / sc);
      color px = im.pixels[y * im.width + x];
      o.pixels[j * o.width + i] = px;
    }
  }
  o.updatePixels();
  return o;  
}
