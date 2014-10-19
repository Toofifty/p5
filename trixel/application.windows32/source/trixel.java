import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.awt.Frame; 
import java.awt.BorderLayout; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class trixel extends PApplet {

/*------------------------------------------
  "Triterion"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/





boolean scan = true;     // move?
boolean trixel = true;   // pixels or trixels?
boolean eq_tri = true;   // use equilaterial tris? (requires 'trixel')
boolean hexels = false;  // use hexels? (requires 'eq_tri')
boolean output = false;  // draw to png and quit?
boolean sat_opac = true; // saturation based opacity?
float sat_power = 2;     // exponent of saturation - opacity
float res = 6;           // resolution : inverse! 10 means less trixels than 5
int opac = 250;          // opacity of the triangles, 0-255

String out = "img";      // name of file output

float v_res;
float h_res;
float tr;
float S3 = sqrt(3);

PImage img;

ControlP5 cp5;
ControlFrame cf;

public void setup () {
  img = loadImage("img.jpg");
  size(img.width, img.height, P3D);
  smooth(8);
  frameRate(60);
  ortho();
  noStroke();
  
  cp5 = new ControlP5(this);
  cf = addControlFrame("Trixel Controls", 200, 200);
}

public void draw () {
  v_res = height / cf.res;
  h_res = width / cf.res;
  image(img, 0, 0);
  filter(GRAY);
  for (int j = -2; j < v_res + 2; j++) {    // -2 and +2 to make sure we
    for (int i = -2; i < h_res + 2; i++) {  // fill the entire screen
      beginShape(TRIANGLES);
        makeTriangles(i, j);
      endShape();
    }
  }
  if (cf.scan) tr += 1;
  if (tr > img.height / v_res) {
    tr -= img.height / v_res; 
  }
  if (cf.saving) {
    saveFrame("tri###.png");
    cf.saving = false;
  }
  if (cf.newimg) {
    selectInput("Select image","fileSelected");
    noLoop();
    cf.newimg = false;
  }
}

public void fileSelected(File selection){
  if(selection == null){
    loop();
  }else{
    String filename = selection.toString();
    print(filename);
    img = loadImage(filename);
    size(img.width, img.height);
    loop();
  }
}
// square-based triangles
public void makeTriangles (int i, int j) {
  if (cf.eq_tri && cf.trixel) {
    makeEqTriangles(i, j);
    return;
  }
  PVector p1 = new PVector(i * cf.res + tr, j * cf.res + tr);
  PVector p2 = new PVector(i * cf.res + tr, (j+1) * cf.res + tr);
  PVector p3 = new PVector((i+1) * cf.res + tr, j * cf.res + tr);
  PVector p4 = new PVector((i+1) * cf.res + tr, (j+1) * cf.res + tr);
  
  PVector c1 = findCentre(p1, p2, p4);
  PVector c2 = findCentre(p1, p3, p4);
  
  int col1 = getColor(c1);
  int col2 = getColor(c2);
  
  fill(col1);
  vvert(p1, red(col1));
  vvert(p2, red(col1));
  vvert(p4, red(col1));
  
  if (cf.trixel) fill(col2);
  vvert(p1, red(col2));
  vvert(p3, red(col2));
  vvert(p4, red(col2));
}

// equilateral triangles
public void makeEqTriangles (int i, int j) {
  float i_ = i;
  float j_ = PApplet.parseFloat(j) * S3;
  PVector c = new PVector(i_ * cf.res + tr, j_ * cf.res + tr*S3);
  PVector p1;
  PVector p2;
  PVector p3;
  
  int col = getColor(c);
  
  fill(col);
  if (j % 2 == 0) {
    if (i % 2 == 0) { // This triangle \u25b2, first line
      p1 = new PVector(i_ * cf.res + tr, (j_+0.5f*S3) * cf.res + tr*S3);
      p2 = new PVector((i_-1) * cf.res + tr, (j_-0.5f*S3) * cf.res + tr*S3);
      p3 = new PVector((i_+1) * cf.res + tr, (j_-0.5f*S3) * cf.res + tr*S3);
    } else {          // This triangle \u25bc, first line
      p1 = new PVector(i_ * cf.res + tr, (j_-0.5f*S3) * cf.res + tr*S3);
      p2 = new PVector((i_-1) * cf.res + tr, (j_+0.5f*S3) * cf.res + tr*S3);
      p3 = new PVector((i_+1) * cf.res + tr, (j_+0.5f*S3) * cf.res + tr*S3);
    }
  } else {
    if (i % 2 != 0) { // This triangle \u25bc, second line
      p1 = new PVector(i_ * cf.res + tr, (j_+0.5f*S3) * cf.res + tr*S3);
      p2 = new PVector((i_-1) * cf.res + tr, (j_-0.5f*S3) * cf.res + tr*S3);
      p3 = new PVector((i_+1) * cf.res + tr, (j_-0.5f*S3) * cf.res + tr*S3);
    } else {          // This triangle \u25b2, second line
      p1 = new PVector(i_ * cf.res + tr, (j_-0.5f*S3) * cf.res + tr*S3);
      p2 = new PVector((i_-1) * cf.res + tr, (j_+0.5f*S3) * cf.res + tr*S3);
      p3 = new PVector((i_+1) * cf.res + tr, (j_+0.5f*S3) * cf.res + tr*S3);
    }
  }
  vvert(p1, red(col));
  vvert(p2, red(col));
  vvert(p3, red(col));
}

public void vvert (PVector p, float z) {
  vertex(p.x, p.y, z);
}

public int getColor (PVector p) {
  if (!cf.sat_opac) return color(img.get(PApplet.parseInt(p.x), PApplet.parseInt(p.y)), cf.opac);
  return color(img.get(PApplet.parseInt(p.x), PApplet.parseInt(p.y)),
               PApplet.parseInt(128 * pow(saturation(img.get(PApplet.parseInt(p.x), PApplet.parseInt(p.y)))/128, cf.sat_power)));
}

public PVector findCentre (PVector p1, PVector p2, PVector p3) {
  float x = (p1.x + p2.x + p3.x) / 3;
  float y = (p1.y + p2.y + p3.y) / 3;
  return new PVector(x, y);
}

public ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}


public class ControlFrame extends PApplet {


  boolean scan = true;     // move?
  boolean trixel = true;   // pixels or trixels?
  boolean eq_tri = true;   // use equilaterial tris? (requires 'trixel')
  boolean hexels = false;  // use hexels? (requires 'eq_tri')
  boolean output = false;  // draw to png and quit?
  boolean sat_opac = true; // saturation based opacity?
  float sat_power = 2;     // exponent of saturation - opacity
  float res = 6;           // resolution : inverse! 10 means less trixels than 5
  int opac = 250;          // opacity of the triangles, 0-255
  
  boolean saving = false;
  boolean newimg = false;

  int w, h;

  int abc = 100;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    cp5.addToggle("scan").setPosition(10, 10);
    cp5.addToggle("trixel").setPosition(50, 10);
    cp5.addToggle("eq_tri").setPosition(90, 10);
    cp5.addToggle("sat_opac").setPosition(130, 10);
    cp5.addSlider("res").setRange(1, 30).setPosition(10, 50);
    cp5.addSlider("opac").setRange(0, 255).setPosition(10, 70);
    cp5.addSlider("sat_power").setRange(0.5f, 5).setPosition(10, 90); 
    
    cp5.addButton("save_frame").setValue(0).setPosition(120, 130);
    cp5.addButton("new_image").setValue(0).setPosition(40, 130);
  }

  public void draw() {
      background(32);
  }
  
  private ControlFrame() {
  }

  public ControlFrame(PApplet theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }
  
  public void save_frame () {
    saving = true;
  }
  
  public void new_image () {
    newimg = true;
  }
  
  
  ControlP5 cp5;

  PApplet parent;

  
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "trixel" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
