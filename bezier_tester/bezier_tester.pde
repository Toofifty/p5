PVector tl = new PVector(-40, -40);
PVector tr = new PVector(40, -40);
PVector br = new PVector(40, 40);
PVector bl = new PVector(-40, 40);

PVector sel;

void setup() {
  size(500, 500);
  stroke(255);
  fill(32);
  
}

void draw() {
  background(32);
  translate(width / 2, height / 2);
  
  beginShape();
  {
    //vertex(tl.x, tl.y);
    //bezierVertex(tr.x, tr.y, br.x, br.y, bl.x, bl.y);
    curveVertex(tl.x, tl.y);
    curveVertex(tr.x, tr.y);
    curveVertex(br.x, br.y);
    curveVertex(bl.x, bl.y);
  }
  endShape();
  
  ellipse(tl.x, tl.y, 5, 5);
  ellipse(tr.x, tr.y, 5, 5);
  ellipse(br.x, br.y, 5, 5);
  ellipse(bl.x, bl.y, 5, 5);
}

void mouseMoved() {
  if (sel != null) {
    sel.x = mouseX - width / 2;
    sel.y = mouseY - height / 2;
  }
}

void keyPressed() {
  switch(keyCode) {
    case 49: // 1
      sel = tl;
      break;
    case 50:
      sel = tr;
      break;
    case 51:
      sel = br;
      break;
    case 52:
      sel = bl;
      break;
    default:
      sel = null;
      println(keyCode);
  }
}