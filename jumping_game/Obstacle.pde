public class Obstacle {
  
  public float h, w = 20;
  public float maxHeight;
  public float x = width;
  public boolean flipped = false;
  
  private float time = 0;
  private float moveTime = 0.4F;
  
  public Obstacle(float _height, float currentProgress, float _w, boolean _flipped) {
    
    maxHeight = _height;
    h = 0;
    x += currentProgress;
    w = _w;
    this.flipped = _flipped;
    
  }  
  
  public Obstacle(float _height, float currentProgress, float _w) {
    
    this(_height, currentProgress, _w, false);
    
  }
  
  public boolean isActive() {
    
    return time != 0;
    
  }
  
  public boolean isDead() {
    
    return x - player.getProgress() + 20 <= 0;
    
  }
  
  public void update() {
    
    if (x - player.getProgress() < width * 5 / 6 && time < 1) {
      
      h = clerp(time) * maxHeight;
      
      time += dt / moveTime;
      
      if (time > 0.2F) {
        
        if (flipped) {
          particles.add(new Particle(x + w / 2, 
              whitespace + h + w / 2, 
              color(128), w / 2, random(2), 100));
        } else {
          particles.add(new Particle(x + w / 2, 
              whitespace + GAME_HEIGHT - h + w / 2, 
              color(128), w / 2, random(2), 100));
        }
        
      }
      
    }
    
  }
  
  public void draw() {
    
    fill(FG);
    if (flipped) {
      
      rect(x - player.getProgress(), whitespace, w, h);
      
    } else {
      
      rect(x - player.getProgress(), whitespace + GAME_HEIGHT - h, w, h);
    
    }
    
  }
  
}
