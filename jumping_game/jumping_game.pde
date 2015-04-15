/* game thing */

import java.util.List;

public final color FG = color(250);
public final color BG = color(32);

public final int WIDTH = 1200;
public final int HEIGHT = 800;
public final int GAME_HEIGHT = 200;

public final float G = 980;

private final float WHITESPACE = (HEIGHT - GAME_HEIGHT) / 2;

private Player player;
private List<Obstacle> obstacles = new ArrayList<Obstacle>();
private List<Particle> particles = new ArrayList<Particle>();

private List<Obstacle> deadObstacles = new ArrayList<Obstacle>();
private List<Particle> deadParticles = new ArrayList<Particle>();

private float time;
public float dt;
public float speed = 0.5;

public void setup() {
  
  size(WIDTH, HEIGHT);
  noStroke();
  colorMode(HSB, 255);
  
  player = new Player();
  
  obstacles.add(new Obstacle(random(60), player.getProgress(), 20));
  
  background(FG);
  
}

public void draw() {
  
  speed += 0.01F;
  
  if (obstacles.size() == 0) {
    obstacles.add(new Obstacle(random(60), player.getProgress(), 20 * sqrt(speed)));
  }
  
  if (obstacles.size() < 4 && obstacles.get(obstacles.size() - 1).isActive() && random(1) > 0.98F) {
    obstacles.add(new Obstacle(random(60), player.getProgress(), 20 * sqrt(speed)));
  }
  
  calcDelta();
  
  background(FG);
  
  fill(BG);
  rect(0, WHITESPACE, WIDTH, GAME_HEIGHT);
  
  for (Obstacle o : obstacles) {
    
    o.update();
    o.draw();
    
    if (o.isDead()) deadObstacles.add(o);
    
  }
  
  player.update();
  player.draw();
  
  translate(-player.getProgress(), 0);
  for (Particle p : particles) {
    
    p.update();
    p.draw();
    
    if (p.isDead()) deadParticles.add(p);
    
  }
  
  for (Particle p : deadParticles) {
    
    particles.remove(p);
    
  }
  
  for (Obstacle o : deadObstacles) {
    
    obstacles.remove(o);
    
  }
  
}

public void keyPressed() {
  if (key == ' ') {
    player.jump();
  }
}

/** Sin Lerps 0-1 to 0-1 */
public float clerp(float i) {
  
  return (-cos(i * PI) + 1) / 2;
  
}

/** Updates delta time, to be ran each frame */
public void calcDelta() {
  
  dt = millis() / 1000F - time;
  time = millis() / 1000F;
  
}
