/*------------------------------------------
  "Beat" Music Visualizer
  By Alex Matheson
    toofifty.me | ello.co/purchase | github.com/toofifty
    
  Music not working? Move "play.mp3" to the same dir as
  the executable.
  
  Music: Mat Zo & Porter Robinson - Easy, available here http://smarturl.it/MZPR-Easy-iTunes

  Free to redistribute under MIT License.
------------------------------------------*/

// Custom variables

public final int SUB_CUBES_AMT = 20;
public final int MAX_SUBC_DIST = 400;    // max distance of sub cubes
public final float PEAK_LEVEL = 5;       // level to create sub cubes
public final float BG_TRANSP = 20;       // background transparency (higher = less fade)
 
import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;
AudioPlayer music;
AudioRenderer beat;

void setup () {  
  
  size(1920, 1080, P3D);
  perspective();
  frameRate(120);
  noStroke();
  
  minim = new Minim(this);
  music = minim.loadFile("play.mp3", 1024);
  music.loop();
  
  beat = new BeatRenderer(music);
  
  music.addListener(beat);
  
}

void draw () {
  
  beat.draw();
  
}

// Audio Renderers credit to Martin Schneider //
abstract class AudioRenderer implements AudioListener {
  float[] left;
  float[] right;
  synchronized void samples(float[] samp) { left = samp; }
  synchronized void samples(float[] sampL, float[] sampR) { left = sampL; right = sampR; }
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
  
  void draw () {
    
    super.calc(10);
    
    translate(0, 0, -1000);                                                          // move back to draw background
    fill(leftFFT[6] * 123 - 50, leftFFT[7] * 123 - 50, leftFFT[8] * 123 - 50, BG_TRANSP); // fill for background based on small channels
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
    
    if (leftFFT[1] > PEAK_LEVEL) {       // check if the largest channel spikes
      
      translate(300, 0, 0);     // move back to centre from cube 3
      
      for (int i = 0; i < SUB_CUBES_AMT; i++) { 
        // create N smaller cubes      
        float tr_x = random(-MAX_SUBC_DIST, MAX_SUBC_DIST);                                                           // randomize x
        float tr_y = random(-sqrt(pow(MAX_SUBC_DIST, 2) - pow(tr_x, 2)), sqrt(pow(MAX_SUBC_DIST, 2) - pow(tr_x, 2))); // randomize y, make sure x + y create a sphere
        float tr_z = random(-MAX_SUBC_DIST, MAX_SUBC_DIST);                                                           // randomize z
        
        translate(tr_x, tr_y, tr_z);             // translate to new position
        box(leftFFT[1] * 10 + random(-50, 50));  // draw small cube dependent on largest channel (already know it is at least 50)
        translate(-tr_x, -tr_y, -tr_x);          // translate back
      
      }
    }
    t++;
    
  }
  
}
