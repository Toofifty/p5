public class Particle {
  
  private PVector position;
  private PVector velocity;
  private color colour;
  
  private float maxSize;
  private float aliveTime;
  
  private float time = 0;
  private float size;
  
  public Particle(float x, float y, color _colour, float _maxSize, float _aliveTime, float maxVel) {
    
    position = new PVector(x, y);
    velocity = new PVector(random(-maxVel, maxVel), random(-maxVel, maxVel));
    colour = _colour;
    maxSize = size = _maxSize;
    aliveTime = _aliveTime;
    
  }
  
  public boolean isDead() {
    return time >= aliveTime;
  }
  
  public void update() {
    
    if (time >= aliveTime) return;
    float timeLeft = aliveTime - time;
    
    position.x += velocity.x * timeLeft / aliveTime * dt;
    position.y += velocity.y * timeLeft / aliveTime * dt;
    
    size = maxSize * (1 - clerp(time / aliveTime));
    
    time += dt;
    
    if (position.y + size / 2 > WHITESPACE + GAME_HEIGHT || position.y - size / 2 < WHITESPACE) {
      velocity.y *= -1;
    }
    
  }
  
  public void draw() {
    
    if (time >= aliveTime) return;
    fill(colour);
    rect(position.x - size / 2, position.y - size / 2, size, size); 
    
  }
  
}
