class Paddle {
  
  PVector pos;
  int dir = 0;
  float dx;
  float vy = -4;
  
  Paddle(float x, float y) {
    
    pos = new PVector(x, y);
    
  }
  
  void update() {
    
    if (gameover) {
      
      vy += 9.8 / frameRate;
      pos.y += vy;
      if (pos.y >= height) restart();
      
    } else {
      
      dx += dir;
      pos.x += dx;
      
      if (pos.x - 100 <= 0) {
        
        pos.x = 100;
        dx = 0;
        
      }
      
      if (pos.x + 100 >= width) {
        
        pos.x = width - 100;
        dx = 0;
        
      }
      
      if (dir == 0) dx *= 0.9F;
      
    }
    
  }
  
  void draw() {
    
    fill(pos.x / width * 255, 128, 255);
    rect(pos.x - 100, pos.y, 200, 20);
    
  }
  
}
