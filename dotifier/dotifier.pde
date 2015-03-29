// CUSTOM
public final String imageName = "img.jpg";
public final boolean colour = true;
public final float dotSize = 16F;
public final color background = color(32);

// VARIABLES
public PImage image;

// COUNTERS
public int offset = 0;

public void setup() {
  image = loadImage(imageName);
  size(image.width / 2, image.height / 2);
  noStroke();
  //noLoop();
  background(background);
  
  generateDots(image);
}

private void generateDots(PImage image) {
  final int xDots = ceil(image.width / dotSize);
  final int yDots = ceil(image.height / dotSize);
  
  for (int i = 0;  i < xDots; i++) {
    for (int j = 0; j < yDots; j++) {
      final int x = int(i * dotSize);
      final int y = int(j * dotSize);
      final color pixel = image.get(x, y);
      final float brightness = (green(pixel) - offset) / 128F;
      // brightness = brightness % 1;
      if (colour) fill(pixel);
      ellipse(x / 2F, y / 2F, brightness / 4F * dotSize, brightness / 4F * dotSize);
      //rect(x / 2F - 2 * dotSize, y / 2F - 2 * dotSize, 2 * dotSize, 2 * dotSize);
    }
  }
}

public void draw() {
  background(background);
  generateDots(image);
  // offset++;
}