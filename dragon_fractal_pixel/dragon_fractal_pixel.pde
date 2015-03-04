public int iteration = 0;
public final int size = 512; // initial. Grows (technically) infinitely larger
PGraphics background;

public void setup() {
  size(size * 2, size * 2, P3D); // must be a multiple of size
  smooth(8);
  frameRate(60);
  background(18, 28, 63);
  fill(124, 14, 194);
  noStroke();
  
}

public void draw() {
  if (frameCount == 1) {
    background = createGraphics(width, height);
    
    float low = 10;
    float high = 0;
  
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        float nv = noise(float(i) / 500.0, float(j) / 500.0);
        float nv1 = noise(float(i + 3000) / 500.0, float(j) / 500.0);
        float nv2 = noise(float(i) / 500.0, float(j + 3000) / 500.0);
        nv -= 0.3;
        nv *= 2;
        if (nv < low) low = nv;
        if (nv > high) high = nv;
        color c = color(243, 50, 69, nv*255);
        background.set(i, j, c);
      }
    }
    println(low + " " + high);
    image(loadImage("img.jpg"), -400, 0);
  }  
}

public void iterate() {
  loadPixels();
  if (iteration % 2 == 0) {
    splitVertical(iteration);
  } else {
    splitHorizontal(iteration);
  }
  iteration++;
  updatePixels();
}

public void splitVertical(int i) {
  int splitwidth = int(size / pow(2, i));
  println("vert" + splitwidth);
  // shift up
  for (int y = 0; y < height; y++) {
    // run for each segment
    for (int n = 0; n < pow(2, i + 1); n++) {
      // calculate start and end
      int startx = n * splitwidth;
      int endx = startx + splitwidth / 2;      
      // shift segment
      for (int x = startx; x < endx; x++) {
        pixels[x + y * width] = getPixel(x, y + splitwidth / 4);
      }
    }
  }
  // shift down
  for (int y = height - 1; y >= 0; y--) {
    // run for each segment
    for (int n = 0; n < pow(2, i + 1); n++) {
      // calculate start and end
      int startx = n * splitwidth + splitwidth / 2;
      int endx = startx + splitwidth / 2;      
      // shift segment
      for (int x = startx; x < endx; x++) {
        pixels[x + y * width] = getPixel(x, y - splitwidth / 4);
      }
    }
  }
}

public void splitHorizontal(int i) {
  int splitheight = int(size / pow(2, i));
  println("horiz" + splitheight);
  // shift right
  for (int x = 0; x < width; x++) {
    // run for each segment
    for (int n = 0; n < pow(2, i + 1); n++) {
      // calculate start and end
      int starty = n * splitheight + splitheight / 2;
      int endy = starty + splitheight / 2;      
      // shift segment
      for (int y = starty; y < endy; y++) {
        pixels[x + y * width] = getPixel(x + splitheight / 4, y);
      }
    }
  }
  // shift left
  for (int x = width - 1; x >= 0; x--) {
    // run for each segment
    for (int n = 0; n < pow(2, i + 1); n++) {
      // calculate start and end
      int starty = n * splitheight;
      int endy = starty + splitheight / 2;      
      // shift segment
      for (int y = starty; y < endy; y++) {
        pixels[x + y * width] = getPixel(x - splitheight / 4, y);
      }
    }
  }
}

public color getPixel(int x, int y) {
  int pos = x + y * width;
  if (pos < 0) return pixels[pos + height * width];
  else if (pos >= height * width) return pixels[pos - height * width];
  else return pixels[x + y * width];
}

public void keyPressed() {
  if (key == ' ') {
    iterate();
  } else if (key == 's') {
    saveFrame("fract.gif");
    saveFrame("fract.tiff");
    saveFrame("fract.tga");
    saveFrame("fract.jpg");
    saveFrame("fract.png");
  }
}
