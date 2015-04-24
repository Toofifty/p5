public class Particle {
  
  private PVector position;
  private PVector velocity;
  private color colour;
  
  private float maxSize;
  private float aliveTime;
  
  private float time = 0;
  private float size;
  
  public Particle(float x, float y, color _colour, float _maxSize, float _aliveTime, float maxVel, boolean noRight) {
    
    position = new PVector(x, y);
    velocity = new PVector(random(-maxVel, noRight ? 0 : maxVel), random(-maxVel, maxVel));
    colour = _colour;
    maxSize = size = _maxSize;
    aliveTime = _aliveTime;
    
  }
  
  public Particle(float x, float y, color _colour, float _maxSize, float _aliveTime, float maxVel) {
    
    this(x, y, _colour, _maxSize, _aliveTime, maxVel, false);
  
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
    
    if (player.dead) time += dt * 100;
    
    if (position.y + size / 2 > whitespace + GAME_HEIGHT) {
      
      velocity.y *= -1;
      position.y = whitespace + GAME_HEIGHT - size / 2;
      
    } else if (position.y - size / 2 < whitespace) {
      
      velocity.y *= -1;
      position.y = whitespace + size / 2;
      
    }
    
  }
  
  public void draw() {
    
    if (time >= aliveTime) return;
    fill(colour);
    rect(position.x - size / 2, position.y - size / 2, size, size); 
    
  }
  
}
