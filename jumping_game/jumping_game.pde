/* game thing */

import java.util.List;

public final boolean DEBUG = false;

public final color FG = color(250);
public final color BG = color(32);

public final int WIDTH = 800;
public final int HEIGHT = 400;
public final int GAME_HEIGHT = 200;

public final float G = 980;

private float whitespace = (HEIGHT - GAME_HEIGHT) / 2;

private Player player;
private List<Obstacle> obstacles = new ArrayList<Obstacle>();
private List<Particle> particles = new ArrayList<Particle>();

private List<Obstacle> deadObstacles = new ArrayList<Obstacle>();
private List<Particle> deadParticles = new ArrayList<Particle>();

private float time;
public float dt;
public float speed = 0.5;

public void setup() {
  
  size(800, 400);
  noStroke();
  colorMode(HSB, 255);
  textSize(10);
  
  player = new Player();
  
  obstacles.add(new Obstacle(random(60), player.getProgress(), 20));
  
  background(FG);
  
}

public void draw() {
  
  speed += 0.005F;
  
  if (player.dead) restart();
  
  if (obstacles.size() == 0) {
    obstacles.add(new Obstacle(random(10, 60), player.getProgress(), 20 * sqrt(speed)));
  }
  
  if (obstacles.size() < 5 && obstacles.get(obstacles.size() - 1).isActive() && random(1) > 0.98F) {
    if (random(1) > 0.15F) {
      obstacles.add(new Obstacle(random(10, GAME_HEIGHT * 0.45F * sqrt(player.getProgress()) / 100), player.getProgress(), 20 * sqrt(speed), true));
    }
    obstacles.add(new Obstacle(random(10, GAME_HEIGHT * 0.45F * sqrt(player.getProgress()) / 100), player.getProgress(), 20 * sqrt(speed)));
  }
  
  calcDelta();
  
  background(FG);
  
  fill(BG);
  rect(0, whitespace, WIDTH, GAME_HEIGHT);
  
  for (Obstacle o : obstacles) {
    
    o.update();
    o.draw();
    
    if (player.collide(o))
      player.kill();
    
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
  
  fill(32);
  text("SCORE:     " + int(player.getProgress()), player.getProgress(), 10);
  text("HIGHSCORE: " + int(player.getBest()), player.getProgress(), 20);
  
}

public void animDeath() {
  
  restart();
  
}

public void restart() {
  
  Player old = player;
  player = new Player();
  player.setBest(old.getBest());
  obstacles.clear();
  particles.clear();
  speed = 0.5;  
  
}

public void keyPressed() {
  
  switch (keyCode) {
  case 37:
    player.move(-1);
    break;
    
  case 39:
    player.move(1);
    break;
    
  case 38:
  case 32:
    player.jump(true);  
    
  }
  
}

public void keyReleased() {
  
  switch (keyCode) {
  case 37:
  case 39:
    player.move(0);
    break; 
    
  case 38:
  case 32:
    player.jump(false); 
    
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