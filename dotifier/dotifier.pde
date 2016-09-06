// CUSTOM
public final String IMAGE_NAME = "img.jpg";
public final boolean COLOUR = true;
public final float DOT_SIZE = 16F;
public final color BG = color(32);

// VARIABLES
public PImage image;

public void setup() {
  
  image = loadImage(IMAGE_NAME);
  size(1000, 1000);
  noStroke();
  //noLoop();
  background(BG);
  
  generateDots(image);
  
  noLoop();
  
}

private void generateDots(PImage image) {
  
  final int xDots = ceil(image.width / DOT_SIZE);
  final int yDots = ceil(image.height / DOT_SIZE);
  
  for (int i = 0;  i < xDots; i++) {
    
    for (int j = 0; j < yDots; j++) {
      
      final int x = int(i * DOT_SIZE);
      final int y = int(j * DOT_SIZE);
      final color pixel = image.get(x, y);
      final float brightness = (green(pixel)) / 128F;
      if (COLOUR) fill(pixel);
      ellipse(x / 2F, y / 2F, brightness / 4F * DOT_SIZE, brightness / 4F * DOT_SIZE);
      
    }
    
  }
  
}