class Block {
  
  color colour;
  PVector pos;
  float size;
  boolean horiz;
  
  Block[] children;
  
  Block(float x, float y, float size, boolean horiz) {
    
    this.colour = color(random(255), 128, 255);
    this.pos = new PVector(x, y);
    this.horiz = horiz;
    this.size = size;
    
  }
  
  boolean collidingWith(Ball b) {
    
    if (horiz) {
      
      return b.pos.x + b.s >= pos.x - size 
          && b.pos.x - b.s <= pos.x + size
          && b.pos.y + b.s >= pos.y - size / 2 
          && b.pos.y - b.s <= pos.y + size / 2;
      
    } else {
      
      return b.pos.x + b.s >= pos.x - size / 2
          && b.pos.x - b.s <= pos.x + size / 2
          && b.pos.y + b.s >= pos.y - size 
          && b.pos.y - b.s <= pos.y + size;
      
    }
    
  }
  
  void collide(Ball b) {
    
    if (children != null) {
      
      children[0].collide(b);
      children[1].collide(b);
      return;
      
    }
    
    if (collidingWith(b)) {
      
      hit();
      if (abs(b.pos.x - pos.x) > size * 0.75) {
        
        b.vel.x *= -1;
        
      } else {
        
        b.vel.y *= -1;
        
      }
      
    }
    
  }
  
  void hit() {
    
    if (horiz) {
      
      children = new Block[]{
        new Block(pos.x - size * 0.25, pos.y, size * 0.4, false),
        new Block(pos.x + size * 0.25, pos.y, size * 0.4, false)
      };
      
    } else {
      
      children = new Block[]{
        new Block(pos.x, pos.y - size * 0.25, size * 0.4, true),
        new Block(pos.x, pos.y + size * 0.25, size * 0.4, true)
      };
      
    }
    
  }
  
  void draw() {
    
    if (children != null) {
      
      children[0].draw();
      children[1].draw();
      return;
      
    }
    
    fill(colour);
    if (horiz) {
      
      rect(pos.x - size, pos.y - size / 2,
        size * 2, size);
        
    } else {
      
      rect(pos.x - size / 2, pos.y - size,
        size, size * 2);
      
    }
    
  }
  
}
