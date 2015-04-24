public class Player {
  
  // pixel progress on x axis
  private float progress;
  private float best;
  private float maxProgress = 1000;
  private float vel = 0;
  private boolean onGround = false;
  
  private float x = WIDTH / 3;
  private float y;
  private int dir;
  private float dx = 0;
  private boolean jumping = false;
  
  private float size = 20;
  
  public boolean dead = false;
  
  public Player() {
    
    progress = 0;
    y = 0;
    
  }
  
  public boolean collide(Obstacle o) {
    
    if (DEBUG) {
        
      fill(128, 255, 255);
      rect(x - size / 2 - 2.5, whitespace + GAME_HEIGHT + y - 2.5, 5, 5);
      rect(x + size / 2 - 2.5, whitespace + GAME_HEIGHT + y - 2.5, 5, 5);
      rect(x - size / 2 - 2.5, whitespace + GAME_HEIGHT + y - size - 2.5, 5, 5);
      rect(x + size / 2 - 2.5, whitespace + GAME_HEIGHT + y - size - 2.5, 5, 5);
        
      if (o.flipped) {
        
        fill(255, 255, 255);
        rect(o.x - progress + o.w - 2.5, whitespace + o.h - 2.5, 5, 5);
        rect(o.x - progress - 2.5, whitespace + o.h - 2.5, 5, 5);
        
      } else {
        
        fill(255, 255, 255);
        rect(o.x - progress + o.w - 2.5, whitespace + GAME_HEIGHT - o.h - 2.5, 5, 5);
        rect(o.x - progress - 2.5, whitespace + GAME_HEIGHT - o.h - 2.5, 5, 5);
        
      }
    }
    
    if (o.flipped && -y + size > GAME_HEIGHT - o.h 
        && x - size / 2 < o.x - progress + o.w 
        && x + size / 2 > o.x - progress) {
      return true;
    } else if (-y < o.h 
        && x - size / 2 < o.x - progress + o.w 
        && x + size / 2 > o.x - progress) {
      return true;
    }
    
    return false;
    
  }
  
  public void kill() {
    
    dead = true;
    
  }
  
  public void move(int dir) {
    
    this.dir = dir;
    
  }
  
  public void jump(boolean jumping) {
    
    if (onGround) {
      vel -= G / 3F;
      onGround = false;
    }
   
    this.jumping = jumping;
    
  }
  
  public color getColor() {
    
    return color((progress % maxProgress) / maxProgress * 255, 128, 255);
    
  }
  
  public float getProgress() {
    
    return progress;
    
  }
  
  public void setBest(float b) {
    
    best = b;
    
  }
  
  public float getBest() {
    
    return best;
    
  }
  
  public void update() {
    
    if (dead) return;
    
    progress += speed;
    if (progress > best) best = progress;
    
    dx += dir;
    x += dx / frameRate * 5;
    
    if (x - size / 2 <= WIDTH / 6) {
      x = WIDTH / 6 + size / 2;
      dx = 0;
    }
    
    if (x + size / 2 >= 5 * WIDTH / 6) {
      x = 5 * WIDTH / 6 - size / 2;
      dx = 0;
    }
    
    if (dir == 0) {
      dx *= onGround ? 0.6F : 0.9F;
    }
    
    if (onGround) {
      vel = 0;
      if (jumping) {
        jump(true);
      }
      return;
    }
    
    if (jumping && vel < 0) {
      vel -= G * 0.7F * dt;
    }
    
    vel += G * dt;
    y += vel * dt;
    
    if (y > 0) {
      onGround = true;
      vel = 0;
      y = 0;
    }
    
  }
  
  public void draw() {
    
    fill(getColor());
    if (dead) {
      if (size >= 40) {
        particles.add(new Particle(x + progress - size / 2, y - size / 2 + whitespace + GAME_HEIGHT, getColor(), size / 2, random(5), 100));
        particles.add(new Particle(x + progress + size / 2, y - size / 2 + whitespace + GAME_HEIGHT, getColor(), size / 2, random(5), 100));
        particles.add(new Particle(x + progress - size / 2, y + size / 2 + whitespace + GAME_HEIGHT, getColor(), size / 2, random(5), 100));
        particles.add(new Particle(x + progress + size / 2, y + size / 2 + whitespace + GAME_HEIGHT, getColor(), size / 2, random(5), 100));
        return;
      }
      size += dt * 10;
      rect(x - size / 2, y - size + HEIGHT - whitespace, size, size);
    } else {
      rect(x - size / 2, y - size + HEIGHT - whitespace, size, size);
      
      if (random(1) <= speed / 10F && !dead) {
        particles.add(new Particle(x + progress, y - size / 2 + whitespace + GAME_HEIGHT, getColor(), size * 2 / 3, random(5), 100, true));
      }
    }
    
  }
  
}
