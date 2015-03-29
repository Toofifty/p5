final int arcrad = 200;
final int arcthick = 160;
float arcstop = 0;
color fg = color(255);
color bg = color(0);

void setup() {
  size(400, 400);
  noStroke();
  fill(255);
  frameRate(60);
  colorMode(HSB, 255);
}

void draw() {
  translate(width / 2, height / 2);
  background(0);
  arcstop = 0.95F * PI * sin(float(frameCount) / 30) + PI + 0.1F;
  drawArc(arcstop, 1.9F, -4F, 1);
  drawArc(arcstop, 1.7F, -3F, -1);
  drawArc(arcstop, 1.5F, -2F, 1);
  drawArc(arcstop, 1.3F, -1F, -1);
  drawArc(arcstop, 1.1F, 0F, 1);
  drawArc(arcstop, 0.9F, 1F, -1);
  drawArc(arcstop, 0.7F, 2F, 1);
  drawArc(arcstop, 0.5F, 3F, -1);
  drawArc(arcstop, 0.3F, 4F, 1);
  drawArc(arcstop, 0.1F, 5F, -1);
}

void drawArc(float angle, float mod, float offset, int dir) {
  fill(64 - 64 * angle / TWO_PI, 255, 255, 128);
  angle += float(frameCount) / 30 + offset;
  if (dir == -1) {
    rotate(-2 * (float(frameCount) / 30 + offset));
  }
  float arcstart = float(frameCount) / 30 + offset;
  arc(0, 0, arcrad * mod, arcrad * mod, arcstart, angle);
  fill(bg);
  ellipse(0, 0, (arcrad - arcthick) * mod, (arcrad - arcthick) * mod);

  if (dir == -1) {
    rotate(2 * (float(frameCount) / 30 + offset));
  }
}
