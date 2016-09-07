import processing.sound.*;
SoundFile music;

FFT fft;
Amplitude amp;
int bands = 512;
float[] sum = new float[bands];

float smoothFactor = 0.2;

float min = 2000;

Segment firstSeg, lastSeg;

int numSegs = 0;
int segSize = 5;

PVector startPoint = new PVector(400, 300);

float factor = 1;

void setup() {
  
  size(2560, 1440, P2D);
  fill(128);
  noStroke();
  //stroke(255);
  colorMode(HSB, 255);
  
  // music
  music = new SoundFile(this, "play.mp3");
  music.loop();
  
  fft = new FFT(this, bands);
  fft.input(music);
  
  background(32);
  
}

void draw() {
  
  //background(32);
  fill(32, 32);
  rect(0, 0, width, height);
  fill((getFourier(bands) * 3 + 96) % 255, 128, 255, 4);
  rect(0, 0, width, height);
  fill((getFourier(bands) * 3 + 96) % 255, 128, 255);
  
  fft.analyze();
  
  for (int i = 0; i < bands; i++) {
    
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothFactor;
    
  }
  
  if (firstSeg != null) {
    
    firstSeg.update();
    
    beginShape();
    {
      //vertex(startPoint.x, startPoint.y, firstSeg.startNormal().x, firstSeg.startNormal().y);
      
      firstSeg.drawVis();
      firstSeg.drawBase();
    }
    endShape();
    
  }
  
}

void addSegment() {
  
  if (firstSeg == null) {
    
    lastSeg = firstSeg = new Segment(mouseX, mouseY, mouseX, mouseY);
    numSegs = 1;
    
  }
  
  if (dist(lastSeg.end.x, lastSeg.end.y, mouseX, mouseY) > segSize) {
    
    lastSeg.addSegment(new Segment(lastSeg.end.x, lastSeg.end.y, mouseX, mouseY));
    
  }
  
}

void keyPressed() {
  
  switch(keyCode) {
    case 82: // R (reset)
      firstSeg = null;
      lastSeg = null;
      numSegs = 0;
      break;
    case 83: // S (set start)
      startPoint.x = mouseX;
      startPoint.y = mouseY;
      min = 1000;
      break;
    default:
      println(keyCode);
  }
  
}

void mouseClicked() { addSegment(); }
void mouseDragged() { addSegment(); }

float getFourier(int n) {
  
  //return (sin((float) n / 10 + ((float)frameCount / 20)) + 1) * 50;
  //println(spectrum[n % bands]);
  //return spectrum[n % bands] * 200 * factor;
  
  return 100 * sum[n % (bands / 2)] * (n % (bands / 2) + 1);
}

class Segment {
  
  PVector start, end;
  PVector normal;
  float normalLength = 0;
  
  Segment nextSeg;
  
  float smooth = 3;

  Segment(float x, float y, float x1, float y1) {
    
    start  = new PVector( x,  y);
    end    = new PVector(x1, y1);
    normal = new PVector(y1 - y, x - x1);
    
  }
  
  void updateNormal() {
    
    normal.normalize().mult(normalLength);
    
  }
  
  PVector startNormal() {
    return normal.copy().add(start);
  }
  
  PVector endNormal() {
    return normal.copy().add(end);
  }
  
  void drawVis() {
    
    //if (this == firstSeg) vertex(start.x, start.y);
    
    vertex(startNormal().x, startNormal().y);
    vertex(endNormal().x, endNormal().y);
    
    if (nextSeg != null) {
      
      vertex(endNormal().x, endNormal().y);
      vertex(nextSeg.startNormal().x, nextSeg.startNormal().y);
      
      //quadraticVertex(endNormal().x, endNormal().y, 
      //  nextSeg.startNormal().x, nextSeg.startNormal().y);
      
      nextSeg.drawVis();
      
    } else {
      
      vertex(endNormal().x, endNormal().y);
      vertex(end.x, end.y);
      
    }
    
  }
  
  Segment getNext() {
    
    return nextSeg;
    
  }
  
  void update() { update(0); }
  
  void update(int n) {
    
    normalLength = getFourier(n);
    updateNormal();
    
    if (nextSeg != null) nextSeg.update(n + 1);
    
  }
  
  void drawBase() {
    
    if (nextSeg != null) {
      
      nextSeg.drawBase();
      
    }
    
    vertex(start.x, start.y);
    vertex(end.x, end.y);
    
  }
  
  void addSegment(Segment seg) {
    
    nextSeg = lastSeg = seg;
    numSegs++;
    
  }
  
}