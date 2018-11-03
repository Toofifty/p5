import processing.core.*;
import java.awt.Color;

/*
 * Player class
 */
 
public class Player {
  static PApplet p;
  
  private int md, rd;
  private float t = 0;
  
  public int lives = 1;
  public float x, y;
  public float dir;
  public static int maxCubes = 21 * 21; // MUST be an uneven square (i.e 11^2)
  public Cube[] blob = new Cube[maxCubes];
  
  private int checking;
  
  public static int playerAmount = 2;
  public static Player[] players = new Player[playerAmount];
  
  public float turnSpeed = 0F;
  public float moveSpeed = 0F;  
  public float turnMax = 0.05F;
  public float moveMax = 2;
  public float turnAccel = 0.005F;
  public float moveAccel = 0.08F;
  public float beamRadius = 0F;
  public float mass = 1;
  
  public Color colour;
  
  public Player (float x, float y, float dir, int player, Color playerColour) {
    
    players[player] = this;
    this.x = x;
    this.y = y;
    this.dir = dir;
    this.colour = playerColour;
    
    // Fill with nulls so we don't have to check the elements
    for (int i = 0; i < maxCubes; i++) {
      blob[i] = null;
    }
    
    blob[posToOrd(0, 0)] = new Cube(x, y, 0, 1);
    blob[posToOrd(0, 0)].attachedTo = this;
    
  }
  
  public static int[] ordToPos (int ord) {
    
    int x = (int)Math.floor(ord % p.sqrt(maxCubes) - (p.sqrt(maxCubes) - 1) / 2);
    int y = (int)Math.floor(ord / p.sqrt(maxCubes) - (p.sqrt(maxCubes) - 1) / 2);
    return new int[]{x, y};
    
  }
 
  public static int posToOrd (int x, int y) {
    
    return Math.round((x + (p.sqrt(maxCubes) - 1) / 2) + (y + (p.sqrt(maxCubes) - 1) / 2) * p.sqrt(maxCubes));
    
  } 
  
  public void moveFB (int md) {
    
    this.md = md;
    
  }
  
  public void rotateLR (int rd) {
    
    this.rd = rd;
    
  }
  
  /* *TO DO*
   * Find proper merge spot
   */
  public int getMergeSpot (Cube cube) {
    
    float magn = p.dist(x, y, cube.x, cube.y);
    float ang;
    if (x > cube.x) {
      ang = (float)Math.atan((cube.y - y) / (cube.x - x)) - ((float)Math.PI - dir);
    } else {
      ang = (float)Math.atan((cube.y - y) / (cube.x - x)) - ((float)Math.PI * 2 - dir);
    }
    int realx = (int)Math.floor(Math.cos(ang) * magn / Cube.cubeSize); // relative to x, y
    int realy = (int)Math.floor(Math.sin(ang) * magn / Cube.cubeSize); // relative to x, y
    int ord = posToOrd(realx, realy);
    
    try {
      
      this.checking = ord;
      
      if (blob[ord] != null) return -1; // Spot taken!
      
      if (blob[ord + 1] == null &&
          blob[ord - 1] == null &&
          blob[ord + (int)Math.sqrt(maxCubes)] == null &&
          blob[ord - (int)Math.sqrt(maxCubes)] == null) {
        return -1; // Can't join on!  
      }
      
      if (cube.cid == 3) { // RED, here's where we destroy stuff
      
        int[] check = new int[]{
          ord + 1, ord - 1,
          ord + (int)Math.sqrt(maxCubes),
          ord - (int)Math.sqrt(maxCubes)
        };
        
        for (int i = 0; i < check.length; i++) {
          if (blob[check[i]] == null) continue;
          
          this.mass -= blob[check[i]].weight;
          
          switch (blob[check[i]].cid) {
            case Cube.WHITE:
              this.lives -= 1;
              break;
            case Cube.BLUE:
              this.turnAccel -= 0.01F;
              break;
            case Cube.GREEN:
              this.moveAccel -= 0.4F;
              break;
            case Cube.YELLOW:
              this.beamRadius -= 0.2F;
              break;
            default:
              break;
          }
          
          blob[check[i]] = null;
        }
        
        for (int i = 0; i < Cube.cubes.size(); i++) {
          if (Cube.cubes.get(i) == cube) {
            Cube.cubes.set(i, null);
          }
        }
        
        return -1; // We're done with the RED
      }
      
      return posToOrd(realx, realy);
    } catch (ArrayIndexOutOfBoundsException e) {
      return -1;
    }
    
  }
  
  public boolean cubeMerge (Cube cube, int ord) {
    
    if (blob[ord] != null) return false;
    
    if (cube.cid == 3) { // RED, should be destroyed!
      return false;
    }
    
    blob[ord] = cube;
    int[] xy = ordToPos(ord);
    
    blob[ord].x = xy[0] * cube.cubeSize;
    blob[ord].y = xy[1] * cube.cubeSize;
    
    this.mass += blob[ord].weight;
    
    switch (blob[ord].cid) {
      case Cube.WHITE:
        this.lives += 1;
        break;
      case Cube.BLUE:
        this.turnAccel += 0.01F;
        break;
      case Cube.GREEN:
        this.moveAccel += 0.4F;
        break;
      case Cube.YELLOW:
        this.beamRadius += 0.2F;
        break;
      default:
        break;
    }
    
    this.moveAccel = Math.max(this.moveAccel, 0.1F);
    this.turnAccel = Math.max(this.turnAccel, 0.1F);
    this.mass = Math.max(this.mass, 1);
    this.beamRadius = Math.max(this.beamRadius, 0);
    
    return true;
    
  }
  
  public boolean inLOS (Cube cube, float angle) {
    angle += Math.PI / 2;
    
    float ldir = dir - beamRadius - 0.1F;
    float rdir = dir + beamRadius + 0.1F;
    
    while (angle > Math.PI) angle -= Math.PI;
    while (angle <= -Math.PI) angle += Math.PI;
    while (ldir > Math.PI) ldir -= Math.PI;
    while (ldir <= -Math.PI) ldir += Math.PI;
    while (rdir > Math.PI) rdir -= Math.PI;
    while (rdir <= -Math.PI) rdir += Math.PI;
    
    if ((-angle >= ldir) && (-angle <= rdir)) {
      return true;
    }
    return false;
  }
  
  public void attract () {
    p.stroke(32);
    p.fill(this.colour.getRGB(), 50);
    p.ellipse(this.x, this.y, this.mass * 35, this.mass * 35);
    
    for (Cube c : Cube.cubes) {
      if (c == null) continue;
      if (c.attachedTo != null) continue;
      if (p.dist(c.x, c.y, this.x, this.y) < this.mass * 17) {
        float angle = (float)Math.atan((this.y - c.y) / (this.x - c.x));
        if (c.x > this.x) {
          angle -= Math.PI;
        }
        
        if (inLOS(c, angle)) {
        
          c.vx += Math.cos(angle) * this.mass / 10;
          c.vy += Math.sin(angle) * this.mass / 10;
          
          c.vx = p.constrain(c.vx, -0.5F, 0.5F);
          c.vy = p.constrain(c.vy, -0.5F, 0.5F);
        }
      }
    }
  }
  
  public void update () {
    
    if (lives <= 0) return;
    
    attract();
    
    turnSpeed += turnAccel * rd / Math.sqrt(mass * 2);
    
    if (rd == 0 && turnSpeed > 0) {
      turnSpeed -= turnAccel / Math.sqrt(mass);
      turnSpeed = Math.max(0, turnSpeed);
    } else if (rd == 0 && turnSpeed < 0) {
      turnSpeed += turnAccel / Math.sqrt(mass);
      turnSpeed = Math.min(0, turnSpeed);
    }
    
    turnSpeed = p.constrain(turnSpeed, -turnMax, turnMax);
    
    dir += turnSpeed;
    
    if (dir > Math.PI) {
      dir -= Math.PI * 2;
    } else if (dir < -Math.PI) {
      dir += Math.PI * 2;
    }
    
    moveSpeed += moveAccel * md / Math.sqrt(mass);
    
    if (md == 0 && moveSpeed > 0) {
      moveSpeed -= moveAccel / Math.sqrt(mass);
      moveSpeed = Math.max(0, moveSpeed);
    } else if (md == 0 && moveSpeed < 0) {
      moveSpeed += moveAccel / Math.sqrt(mass);
      moveSpeed = Math.min(0, moveSpeed);
    }
    
    moveSpeed = p.constrain(moveSpeed, -moveMax, moveMax);
    
    x = x + (float)Math.sin(dir) * moveSpeed;
    y = y + (float)Math.cos(dir) * moveSpeed;
    
    x = p.constrain(x, 0, p.width);
    y = p.constrain(y, 0, p.height);
    
  }
  
  public void draw () {
    
    if (lives <= 0) return;
    
    p.translate(x, y);
    p.rotate(-dir);
    
    p.stroke(32);
    p.noFill();
    
    /*for (int i = 0; i < maxCubes; i++) {
      int[] pos = ordToPos(i);
      if (i == this.checking) p.fill(255, 0, 0);
      p.translate(Cube.cubeSize * pos[0], Cube.cubeSize * pos[1]);
      p.box(Cube.cubeSize);
      p.translate(-Cube.cubeSize * pos[0], -Cube.cubeSize * pos[1]);
      p.noFill();
    }*/
        
    for (int i = 0; i < maxCubes; i++) {
      try {
        blob[i].draw();
      } catch (NullPointerException e) {
        continue;
      }
    }
    
    p.rotate(dir);
    p.translate(-x, -y);
    
    float x1a = (float)Math.sin(dir - beamRadius) * mass * 5;
    float y1a = (float)Math.cos(dir - beamRadius) * mass * 5;
    
    float x2a = (float)Math.sin(dir + beamRadius) * mass * 5;
    float y2a = (float)Math.cos(dir + beamRadius) * mass * 5;
    
    for (int i = 0; i < 4; i++) {
      p.stroke(this.colour.getRGB(), 255 / (i+1));
      
      float p1x, p1y, p1x_, p1y_;
      p1x = p1y = p1x_ = p1y_ = 0;
      
      if (dir - beamRadius >= 0 && dir - beamRadius < Math.PI / 2) { // bottom right
      
        p1x = Math.max(x, x + x1a * (i-t));
        p1y = Math.max(y, y + y1a * (i-t));
        
        p1x_ = Math.max(x, x + x1a * (i+0.5F-t));
        p1y_ = Math.max(y, y + y1a * (i+0.5F-t));
      
      } else if (dir - beamRadius >= Math.PI / 2) { // top right
        
        p1x = Math.max(x, x + x1a * (i-t));
        p1y = Math.min(y, y + y1a * (i-t));
        
        p1x_ = Math.max(x, x + x1a * (i+0.5F-t));
        p1y_ = Math.min(y, y + y1a * (i+0.5F-t));
        
      } else if (dir - beamRadius < 0 && dir - beamRadius > -Math.PI / 2) { // bottom left
        
        p1x = Math.min(x, x + x1a * (i-t));
        p1y = Math.max(y, y + y1a * (i-t));
        
        p1x_ = Math.min(x, x + x1a * (i+0.5F-t));
        p1y_ = Math.max(y, y + y1a * (i+0.5F-t));
        
      } else { // top left
        
        p1x = Math.min(x, x + x1a * (i-t));
        p1y = Math.min(y, y + y1a * (i-t));
        
        p1x_ = Math.min(x, x + x1a * (i+0.5F-t));
        p1y_ = Math.min(y, y + y1a * (i+0.5F-t));
        
      }
      
      p.line(p1x, p1y, p1x_, p1y_); 
      if (beamRadius != 0.0) {
        
        float p2x, p2y, p2x_, p2y_;
        p2x = p2y = p2x_ = p2y_ = 0;
        
        if (dir + beamRadius >= 0 && dir + beamRadius < Math.PI / 2) { // bottom right
        
          p2x = Math.max(x, x + x2a * (i-t));
          p2y = Math.max(y, y + y2a * (i-t));
          
          p2x_ = Math.max(x, x + x2a * (i+0.5F-t));
          p2y_ = Math.max(y, y + y2a * (i+0.5F-t));
        
        } else if (dir + beamRadius >= Math.PI / 2) { // top right
          
          p2x = Math.max(x, x + x2a * (i-t));
          p2y = Math.min(y, y + y2a * (i-t));
          
          p2x_ = Math.max(x, x + x2a * (i+0.5F-t));
          p2y_ = Math.min(y, y + y2a * (i+0.5F-t));
          
        } else if (dir + beamRadius < 0 && dir + beamRadius > -Math.PI / 2) { // bottom left
          
          p2x = Math.min(x, x + x2a * (i-t));
          p2y = Math.max(y, y + y2a * (i-t));
          
          p2x_ = Math.min(x, x + x2a * (i+0.5F-t));
          p2y_ = Math.max(y, y + y2a * (i+0.5F-t));
          
        } else { // top left
          
          p2x = Math.min(x, x + x2a * (i-t));
          p2y = Math.min(y, y + y2a * (i-t));
          
          p2x_ = Math.min(x, x + x2a * (i+0.5F-t));
          p2y_ = Math.min(y, y + y2a * (i+0.5F-t));
          
        }
        p.line(p2x, p2y, p2x_, p2y_); 
      }
    }
    
    p.noStroke();
    t += 0.01F;
    if (t > 1) t = 0;
  }
}
