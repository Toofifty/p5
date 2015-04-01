int boxsize = 128;
int gap = 0; // is multiplied by 2
int sat = 150;

float movement = 0;
int stage = 0;
float cpos = boxsize / 2 + gap;

void setup() {
  size(512, 512);
  background(32);
  frameRate(60);
  fill(255);
  noStroke();
  colorMode(HSB, 255);
}

void draw() {
  background(32);
  translate(height / 2, width / 2);
  float sinpos = sin((movement - 30) * PI / 60F);
  int colorHue = int(((sinpos + 1) / 2 + stage) * 64);
  
  fill(colorHue, 128, 255, 255 - 255 * (sinpos / 2 + 0.5F));
  switch(stage) {
  case 0:
    centreBox(cpos, -cpos, boxsize);
    fill(colorHue, sat, 255);
    centreBox(-cpos, -cpos, boxsize);
    centreBox(-cpos, sinpos * cpos, boxsize);
    break;
  case 1:
    centreBox(-cpos, -cpos, boxsize);
    fill(colorHue, sat, 255);
    centreBox(-cpos, cpos, boxsize);
    centreBox(cpos * sinpos, cpos, boxsize);
    break;
  case 2:
    centreBox(-cpos, cpos, boxsize);
    fill(colorHue, sat, 255);
    centreBox(cpos, cpos, boxsize);
    centreBox(cpos, sinpos * -cpos, boxsize);
    break;
  case 3:
    centreBox(cpos, cpos, boxsize);
    fill(colorHue, sat, 255);
    centreBox(cpos, -cpos, boxsize);
    centreBox(sinpos * -cpos, -cpos, boxsize);
  }
  movement++;
  if (movement >= 60) {
    movement = 0;
    stage++;
    if (stage > 3) {
      stage = 0;
    }
  }
}

void centreBox(float x, float y, float size) {
  rect(x - size / 2,y - size / 2, size, size);
  //ellipse(x, y, size, size);
}
