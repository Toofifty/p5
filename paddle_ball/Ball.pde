class Ball {
  
  PVector pos;
  PVector vel;
  float s = 20;
  
  Ball(float x, float y) {
    
    pos = new PVector(x, y);
    vel = new PVector(random(-2, 2), 3);
    
  }
  
  void update() {
    
    pos.x += vel.x;
    pos.y += vel.y;
    
    if (pos.x + s/2 >= width || pos.x - s/2 <= 0) {
      vel.x *= -1;
    }
    
    if (pos.y - s/2 <= 0) {
      vel.y *= -1;
    }
    
    gameover = pos.y + s/2 >= height;
    
  }
  
  void collide(Paddle p) {
    
    if (collidingWith(p)) {
      
      vel.y *= -1;
      
      float ballToPaddle = dist(p.pos.x, p.pos.y, pos.x, pos.y);
      
      if (ballToPaddle >= 50) {
        
        vel.x += ballToPaddle / 25 * (pos.x > p.pos.x ? 1 : -1);
        
      }
      
    }
    
  }
  
  boolean collidingWith(Paddle p) {
    
    return (pos.y + s/2 >= p.pos.y) && pos.x - s/2 <= p.pos.x + 100 && pos.x + s/2 >= p.pos.x - 100;
  
  }
  
  void draw() {
    
    fill(pos.y / height * 255, 128, 255);
    ellipse(pos.x, pos.y, s, s);
    
  }
  
}
