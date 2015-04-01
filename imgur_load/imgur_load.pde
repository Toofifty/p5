final int arcrad = 200;
final int arcthick = 20;
color fg = color(255);
color bg = color(0);
float arcstart;

void setup() {
  size(400, 400);
  noStroke();
  fill(fg);
  frameRate(60);
}

void draw() {
  float arcstop = 0.8F * PI * sin(float(frameCount) / 20) + PI + 0.1F;
  arcstart += (sin(float(frameCount) / 20) + 1) / 17;
  arcstop += arcstart;
  
  translate(width / 2, height / 2);
  background(bg);
  fill(fg);
  arc(0, 0, arcrad, arcrad, arcstart, arcstop);
  fill(bg);
  ellipse(0, 0, arcrad - arcthick, arcrad - arcthick);
}
