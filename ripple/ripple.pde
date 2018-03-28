/*------------------------------------------
  "Ripple"
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty

  Free to redistribute under MIT License.
------------------------------------------*/

boolean gridPoints = false; // OR random
boolean topView = true; // OR side view
boolean randomColours = true; // OR white
boolean redraw = true;
float rate = 2.05; // Negative resonates outwards
float zHeight = 20; // General height multiplier
float maxZHeight = 20000; // Set super big for no max height
float distanceDilate = 40; // Determines max height too, inverse relationship, do not make 0
float spreadDilate = 10; // Amount that spread affects height
float antiSpike = 0.1; // Higher number reduces the huge spike in the centre, but makes all waves smaller
int whitespaceX = 400;
int whitespaceY = 400;
int numPointsX = 100;
int numPointsY = 100;
int alphaFade = 0; // Set to 255 to disable fading
int heightDilate = 5; // Exponent dilating height by distance
int fadeType = 1; // 0: Height-based, 1: Distance-based, 2: Random

Point[] points;
float maxDistance;
float[] centre;
int nY;
int nX;
boolean uiActive = false;
Button uiToggle = new Button(5f, 5f, 100f, 25f, "Toggle UI", uiActive, this);
Button animRefresh = new Button(110f, 5f, 100f, 25f, "Refresh sim", false, this);
Button defaults = new Button(215f, 5f, 100f, 25f, "Reset all", false, this);
Button[] boolOptions = new Button[7];
Button[] floatLabels = new Button[6];
FloatSlider[] floatSliders = new FloatSlider[6];
Button[] intLabels = new Button[7];
IntSlider[] intSliders = new IntSlider[7];

int[][] cyanHues = new int[][]{
  new int[]{ 102, 153, 153 },
  new int[]{ 0, 51, 51 },
};
int[][] orangeHues = new int[][]{
  new int[]{ 255, 211, 170 },
  new int[]{ 85, 41, 0 },
};

void setup () {
  createbuttons();
  // Setup
  size(1280, 720, P3D);
  begin();
}

void createbuttons () {
  // Create buttons  
  
  /// Booleans
  boolOptions[0] = new Button(5f, 35f, 100f, 25f, "Point grid", gridPoints, this);
  boolOptions[1] = new Button(5f, 65f, 100f, 25f, "Top view", topView, this);
  boolOptions[2] = new Button(110f, 35f, 100f, 25f, "Colours", randomColours, this);
  boolOptions[3] = new Button(110f, 65f, 100f, 25f, "Redraw", redraw, this);
  boolOptions[4] = new Button(215f, 35f, 100f, 25f, "Orange hues", false, this);
  boolOptions[5] = new Button(215f, 65f, 100f, 25f, "Cyan hues", false, this);
  boolOptions[6] = new Button(215f, 95f, 100f, 25f, "O/C hue mix", false, this);
  
  /// Float labels
  floatLabels[0] = new Button(5f, 125f, 100f, 25f, "Wave rate", false, this);
  floatLabels[1] = new Button(5f, 155f, 100f, 25f, "Height mult", false, this);
  floatLabels[2] = new Button(5f, 185f, 100f, 25f, "Max height", false, this);
  floatLabels[3] = new Button(5f, 215f, 100f, 25f, "Distance coeff.", false, this);
  floatLabels[4] = new Button(5f, 245f, 100f, 25f, "Spread coeff.", false, this);
  floatLabels[5] = new Button(5f, 275f, 100f, 25f, "Anti-spike", false, this);
  
  /// Float sliders
  floatSliders[0] = new FloatSlider(110f, 125f, 100f, 25f, rate, -3f, 3f, this);
  floatSliders[1] = new FloatSlider(110f, 155f, 100f, 25f, zHeight, -100f, 100f, this);
  floatSliders[2] = new FloatSlider(110f, 185f, 100f, 25f, maxZHeight, 0f, 20000f, this);
  floatSliders[3] = new FloatSlider(110f, 215f, 100f, 25f, distanceDilate, -100f, 100f, this);
  floatSliders[4] = new FloatSlider(110f, 245f, 100f, 25f, spreadDilate, -100f, 100f, this);
  floatSliders[5] = new FloatSlider(110f, 275f, 100f, 25f, antiSpike, 0f, 10f, this);
  
  /// Int labels
  intLabels[0] = new Button(5f, 305f, 100f, 25f, "# X points", false, this);
  intLabels[1] = new Button(5f, 335f, 100f, 25f, "# Y points", false, this);
  intLabels[2] = new Button(5f, 365f, 100f, 25f, "Alpha fade", false, this);
  intLabels[3] = new Button(5f, 395f, 100f, 25f, "Height exp.", false, this);
  intLabels[4] = new Button(5f, 425f, 100f, 25f, "Fade type", false, this);
  intLabels[5] = new Button(5f, 455f, 100f, 25f, "X white space", false, this);
  intLabels[6] = new Button(5f, 485f, 100f, 25f, "Y white space", false, this);
  
  /// Int sliders
  intSliders[0] = new IntSlider(110f, 305f, 100f, 25f, numPointsX, 0, 2000, this);
  intSliders[1] = new IntSlider(110f, 335f, 100f, 25f, numPointsY, 0, 2000, this);
  intSliders[2] = new IntSlider(110f, 365f, 100f, 25f, alphaFade, 0, 255, this);
  intSliders[3] = new IntSlider(110f, 395f, 100f, 25f, heightDilate, 0, 8, this);
  intSliders[4] = new IntSlider(110f, 425f, 100f, 25f, fadeType, 0, 4, this);
  intSliders[5] = new IntSlider(110f, 455f, 100f, 25f, whitespaceX, 0, 1000, this);
  intSliders[6] = new IntSlider(110f, 485f, 100f, 25f, whitespaceY, 0, 1000, this);
}

void drawui () {
  uiToggle.draw();
  if (!uiActive) return;
  animRefresh.draw();
  defaults.draw();
  for (int i = 0; i < boolOptions.length; i++) {
    boolOptions[i].draw();
  }
  for (int i = 0; i < floatLabels.length; i++) {
    floatLabels[i].draw();
  }
  for (int i = 0; i < floatSliders.length; i++) {
    floatSliders[i].draw();
  }
  for (int i = 0; i < intLabels.length; i++) {
    intLabels[i].draw();
  }
  for (int i = 0; i < intSliders.length; i++) {
    intSliders[i].draw();
  }
}

void mousePressed () {
  // UI Toggle
  if (uiToggle.inbounds(mouseX, mouseY)) {
    uiActive = !uiActive;
    uiToggle.setactive(uiActive);
    begin();
  } else if (animRefresh.inbounds(mouseX, mouseY)) {
    begin();
  } else if (defaults.inbounds(mouseX, mouseY)) {
    createbuttons();
    begin();
  }
  if (!uiActive) return;
  for (int i = 0; i < boolOptions.length; i++) {
    if (boolOptions[i].inbounds(mouseX, mouseY)) {
      boolOptions[i].a = !boolOptions[i].a;
    }
  }
  for (int i = 0; i < floatSliders.length; i++) {
    if (floatSliders[i].inbounds(mouseX, mouseY)) {
      floatSliders[i].update(mouseX);
    }
  }
  for (int i = 0; i < intSliders.length; i++) {
    if (intSliders[i].inbounds(mouseX, mouseY)) {
      intSliders[i].update(mouseX);
    }
  }
}

void begin () {
  background(0);
    
  // Initial variable setting
  points = new Point[ int(intSliders[0].val() * intSliders[1].val()) ];
  centre = new float[]{ intSliders[5].val()/2, intSliders[6].val()/2, 0 };
  float[] fp = new float[]{ ( width - intSliders[5].val() )/2, ( height - intSliders[6].val() )/2, 0 };
  maxDistance = dist(fp[0],fp[1],fp[2], centre[0], centre[1], centre[2]);
  
  // Create points
  if ( boolOptions[0].a() ) {
    for (int j = 0; j < intSliders[1].val(); j++) {
      for (int i = 0; i < intSliders[0].val(); i++) {
        int k = j * int(intSliders[0].val()) + i;
        float x = i * ( width - intSliders[5].val() ) / intSliders[0].val();
        float y = j * ( height - intSliders[6].val() ) / intSliders[1].val();
        points[k] = new Point(x, y, 0);
      }
    }
  } else {
    for (int j = 0; j < intSliders[0].v * intSliders[1].v; j++) {
      float x = random( width - intSliders[5].val() );
      float y = random( height - intSliders[6].val() );
      points[j] = new Point(x, y, 0);
    }
  }
  nY = int(intSliders[0].val());
  nX = int(intSliders[1].val());
  print(nY +" : "+nX +" | ");
  print(intSliders[0].val() +" : "+intSliders[1].val() +" | ");
}

void draw () {
  if ( boolOptions[3].a() ) background(0);
  drawui();
  translate( intSliders[5].val() / 2, intSliders[6].val() / 2 );
  for (int j = 0; j < nY; j++) {
    beginShape(POINTS);
    for (int i = 0; i < nX; i++) {
      points[j*nX + i].update();
      points[j*nX + i].display();
    }
    endShape();
  }
}

int[] lerpcolour (int[] c1, int[] c2, float i) {
  if (i > 1) i = 1;
  if (i < 0) i = 0;
  int[] out = new int[3];
  for (int n = 0; n < 3; n++) {
    out[n] = int(c1[n] + i * (c2[n] - c1[n]));
  }
  return out;
}
