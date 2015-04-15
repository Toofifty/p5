public class Obstacle {
  
  public float h, w = 20;
  private float maxHeight;
  public float x = width;
  public boolean flipped = false;
  
  private float time = 0;
  private float moveTime = 0.4F;
  
  public Obstacle(float _height, float currentProgress, float _w) {
    
    maxHeight = _height;
    h = 0;
    x += currentProgress;
    w = _w;
    
  }  
  
  public boolean isActive() {
    return time != 0;
  }
  
  public boolean isDead() {
    return x - player.getProgress() + 20 <= 0;
  }
  
  public void update() {
    
    if (x - player.getProgress() < width * 3 / 4 && time < 1) {
      
      h = clerp(time) * maxHeight;
      
      time += dt / moveTime;
      
      if (time > 0.2F) {
        
        particles.add(new Particle(x + w / 2, WHITESPACE + GAME_HEIGHT - h + w / 2, FG, w / 2, random(2), 100));
        
      }
      
    }
    
  }
  
  public void draw() {
    fill(FG);
    rect(x - player.getProgress(), WHITESPACE + GAME_HEIGHT - h, w, h);
  }
  
}
