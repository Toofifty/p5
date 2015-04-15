public class Player {
  
  // pixel progress on x axis
  private float progress;
  private float maxProgress = 1000;
  private float vel = 0;
  private boolean onGround = false;
  
  private float x = WIDTH / 3;
  private float y;
  
  private float size = 20;
  
  public Player() {
    
    progress = 0;
    y = 0;
    
  }
  
  public void jump() {
    
    if (!onGround) return;
    
    vel -= 500;
    onGround = false;
    
  }
  
  public color getColor() {
    
    return color((progress % maxProgress) / maxProgress * 255, 128, 255);
    
  }
  
  public float getProgress() {
    
    return progress;
    
  }
  
  public void checkCollides() {
    
    
    
  }
  
  public void update() {
    
    progress += speed;
    if (onGround) return;
    
    println("update");
    
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
    rect(x - size / 2, y - size + HEIGHT - WHITESPACE, size, size);
    
    if (random(1) <= speed / 10F) {
      particles.add(new Particle(x + progress, y - size / 2 + WHITESPACE + GAME_HEIGHT, getColor(), size * 2 / 3, random(10), 100));
    }
    
    
  }
  
}
