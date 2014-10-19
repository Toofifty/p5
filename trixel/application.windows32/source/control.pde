ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
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
    cp5.addSlider("sat_power").setRange(0.5, 5).setPosition(10, 90); 
    
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

