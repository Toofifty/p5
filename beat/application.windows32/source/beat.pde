/*------------------------------------------
  "Beat" Music Visualizer
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty
    
  Music not working? Move "play.mp3" to the same dir as
  the executable.

  Free to redistribute under MIT License.
------------------------------------------*/

// "Play with me!" variables.

public int sub_cubes_amount = 20;  // amount of sub cubes
public int max_sub_d = 400;        // max distance of sub cubes
public float peak_level = 5;       // level to create sub cubes
public float bg_t = 20;            // background transparency (higher = less fade)

// "Don't touch!" variables.
 
import ddf.minim.*;           // import Minim
import ddf.minim.analysis.*;  // import FFT things
Minim minim;                  // create variables
AudioPlayer music;
AudioRenderer beat;

// Processing setup call
void setup () {
                               // Graphics Setup //
  size(1920, 1080, P3D);       // size
  perspective();               // perspective
  frameRate(120);              // set framerate
  
                                             // Minim Player creation //
  minim = new Minim(this);                   // create
  music = minim.loadFile("play.mp3", 1024);  // load "play.mp3" in directory
  music.loop();                              // loop music
  
  beat = new BeatRenderer(music);            // create music visualizer
  
  music.addListener(beat);                   // send music to beat renderer
  
  beat.setup();
}

// Processing draw call
void draw () {
  beat.draw();
}

/*------------------------------------------
  Moved renderer here to help with
  variable playing :)
------------------------------------------*/

// Audio Renderers credit to Martin Schneider //
abstract class AudioRenderer implements AudioListener {
  float[] left;
  float[] right;
  synchronized void samples(float[] samp) { left = samp; }
  synchronized void samples(float[] sampL, float[] sampR) { left = sampL; right = sampR; }
  abstract void setup();
  abstract void draw();
}


abstract class FourierRenderer extends AudioRenderer {
  FFT fft;
  float maxFFT;
  float[] leftFFT;
  float[] rightFFT;
  
  FourierRenderer (AudioSource s) {
    float gain = 0.125;
    fft = new FFT(s.bufferSize(), s.sampleRate());
    maxFFT = s.sampleRate() / s.bufferSize() * gain;
    fft.window(FFT.HAMMING);
  }
  
  void calc (int bands) {
    if (left != null) {
      leftFFT = new float[bands];
      fft.linAverages(bands);
      fft.forward(left);
      for (int i = 0; i < bands; i++) {
        leftFFT[i] = fft.getAvg(i);
      }
    }
  }
}
// Audio Renderers credit to Martin Schneider //

// Actual visualizer class
class BeatRenderer extends FourierRenderer {
  
  int n = 10;   // number of channels
  float t = 0;
  
  BeatRenderer (AudioSource s) {
    super(s);
  }
  
  void setup () {
    noStroke();
  }
  
  void draw () {
    super.calc(10);
    
    translate(0, 0, -1000);                                                          // move back to draw background
    fill(leftFFT[6] * 123 - 50, leftFFT[7] * 123 - 50, leftFFT[8] * 123 - 50, bg_t); // fill for background based on small channels
    rect(-width / 2, -height / 2, width * 2, height * 2);                            // draw background with transparency for blur-like effects
    translate(width / 2, height / 2, 1000);                                          // move to original, and into the centre
    
    fill(leftFFT[3] * 123, leftFFT[4] * 123, leftFFT[5] * 123, 200);  // fill for centre 3 cubes (3, 4, 5) moderate channels
    rotateX(t / 100 + leftFFT[9] * 10);                               // constantly rotates the cubes, need to add some random here
    rotateY(t / 100 - leftFFT[9] * 10);                               // (9) is the smallest channel
    rotateZ(t / 100 - leftFFT[9] * 10);
    
    box(leftFFT[1] * 10 + 100);                // draw the first, main cube - min size is 100 but fluctuates less (1) is the largest channel
    translate(300 + leftFFT[1] * 10, 0, 0);    // move to draw cube 2
    box(leftFFT[1] * 30 + 10);                 // draw cube 2, small min size but more fluctuation
    translate(-600 - leftFFT[1] * 20, 0, 0);   // move to the other size of cube 1
    box(leftFFT[1] * 30 + 10);                 // draw cube 3
    
    if (leftFFT[1] > peak_level) {       // check if the largest channel spikes
      translate(300, 0, 0);     // move back to centre from cube 3
      
      for (int i = 0; i < sub_cubes_amount; i++) {                                                            // create N smaller cubes      
        float tr_x = random(-max_sub_d, max_sub_d);                                                           // randomize x
        float tr_y = random(-sqrt(pow(max_sub_d, 2) - pow(tr_x, 2)), sqrt(pow(max_sub_d, 2) - pow(tr_x, 2))); // randomize y, make sure x + y create a sphere
        float tr_z = random(-max_sub_d, max_sub_d);                                                           // randomize z
        
        translate(tr_x, tr_y, tr_z);             // translate to new position
        box(leftFFT[1] * 10 + random(-50, 50));  // draw small cube dependent on largest channel (already know it is at least 50)
        translate(-tr_x, -tr_y, -tr_x);          // translate back
      }
    }
    t++;
  }
  
}
