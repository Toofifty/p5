import processing.core.*;
import java.awt.Color;
import java.util.*;


/*
 * Cube class
 */
 
public class Cube {  
  static PApplet p;
  
  public float x, y;
  public float vx, vy;
  public float dir;
  public float weight;
  public int cid;
  public Player attachedTo;
  public Color colour;
  
  public static int cubeSize = 10;
  public static int cubeAmount;
  
  public static final int WHITE = 0;
  public static final int GREY = 1;
  public static final int DARKGREY = 2;
  public static final int RED = 3;
  public static final int BLUE = 4;
  public static final int GREEN = 5;
  public static final int YELLOW = 6;
  
  public static ArrayList<Cube> cubes = new ArrayList<Cube>();
  public static Color[] colours = new Color[7];
  
  public Cube (float x, float y, int colour, float weight) {
    this.x = x;
    this.y = y;
    this.vx = p.random(-0.1F, 0.1F);
    this.vy = p.random(-0.1F, 0.1F);
    this.colour = colours[colour];
    this.cid = colour;
    this.weight = weight;
    this.dir = 0;
  }
  
  public void update () {
    
    this.x += this.vx;
    this.y += this.vy;
    
    if (this.x > p.width || this.x < 0) {
      this.vx *= -1;
    }
    
    if (this.y > p.height || this.y < 0) {
      this.vy *= -1;
    }   
    
    float checkDist = ((float)Math.sqrt(Player.maxCubes) + 1) / 2 * cubeSize;
    
    p.stroke(32);
    p.noFill();
    //p.ellipse(x, y, checkDist * 2, checkDist * 2);
    
    for (int i = 0; i < Player.playerAmount; i++) {
      
      if (Player.players[i].lives <= 0) continue;
      
      if (Math.abs(this.x - Player.players[i].x) < checkDist && Math.abs(this.y - Player.players[i].y) < checkDist && attachedTo == null) {
        
        int mergeSpot = Player.players[i].getMergeSpot(this);
        
        // If no mergeSpot found, we'll try next frame.
        if (mergeSpot == -1) continue;
        
        if (Player.players[i].cubeMerge(this, mergeSpot)) {
          this.vx = this.vy = 0;
        }
      }
    }   
    
  }
  
  public void draw () {
    
    if (attachedTo == null) {
      
      p.translate(x, y);
      p.rotateX(p.frameCount / 100.0F * this.vx);
      p.rotateY(p.frameCount / 100.0F * this.vx);
      
    }
    
    p.fill(colour.getRGB());
    p.stroke(0);
    p.box(cubeSize);
    p.noStroke();
    
    if (attachedTo == null) {
      
      p.rotateY(p.frameCount / -100.0F * this.vx);
      p.rotateX(p.frameCount / -100.0F * this.vx);
      p.translate(-x, -y);
      
    }
    
  }
  
}
