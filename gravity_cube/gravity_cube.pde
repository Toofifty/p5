/*==================================

  Gravity cube
    - Toofifty
    
  Aim:
    Attract as many pieces to your cube as possible,
  and try to gather more than any other players.
  
  The game ends when all cubes are used or only one player stands.
  Players can actively attack others by drawing red cubes (or dark grey)
  towards them, destroying (or slowing) their blob.
  
  You are a white cube. Each additional cube you gain increases
  your mass and gravity, and allows you to attract more.
  
  Cubes are attracted by a laser coming from the front of
  your cube, which is controlled by the left/right arrows -
  or equivalent.
  
  You can move forwards and backwards with the corresponding
  keys.
  
  All cubes add to the mass of the blob, and will reduce
  it's manouvring speed.
  
  Grey cubes have no significant effect, but do add to your
  gravity.
  
  Dark grey cubes are trash, and have no benefits. They slow down
  turning and moving.
  
  Red cubes are dangerous, and will destroy your outermost
  cube. If your all your white cubes are destroyed, you lose.
  
  Blue cubes allow you to turn faster.
  
  Green cubes allow you to move faster.
  
  Yellow cubes increase the radius of your attraction beam.
  
  White cubes are +1's. You will only die if you have none of these.

==================================*/

/* Imports */

import processing.core.*;
import java.awt.Color;
import ddf.minim.*;

/* Global variables */

static final int playerAmount = 2;
static final int initCubes = 50;
static final int cubeAmount = 100;
PGraphics background;

Minim minim;
AudioPlayer music;

/* End globals */

/*
 * Grab keypress movements
 */

void keyPressed () {
  try {
    switch(keyCode) {
      /* Player 0 gets the arrow keys */
      case 38:
        Player.players[0].moveFB(1);
        break;
      case 40:
        Player.players[0].moveFB(-1);
        break;
      case 37:
        Player.players[0].rotateLR(1);
        break;
      case 39:
        Player.players[0].rotateLR(-1);
        break;
        
      /* Player 1 gets the wasd keys */
      case 87:
        Player.players[1].moveFB(1);
        break;
      case 83:
        Player.players[1].moveFB(-1);
        break;
      case 65:
        Player.players[1].rotateLR(1);
        break;
      case 68:
        Player.players[1].rotateLR(-1);
        break;
        
      default:
        print(keyCode);        
    }
  } catch (ArrayIndexOutOfBoundsException e) {
    return;
  }
}

/*
 * Grab keyrelease movements
 */

void keyReleased () {
  try {
    
    switch(keyCode) {
      /* Player 0 gets the arrow keys */
      case 38:
        Player.players[0].moveFB(0);
        break;
      case 40:
        Player.players[0].moveFB(0);
        break;
      case 37:
        Player.players[0].rotateLR(0);
        break;
      case 39:
        Player.players[0].rotateLR(0);
        break;
      
      /* Player 1 gets the wasd keys */
      case 87:
        Player.players[1].moveFB(0);
        break;
      case 83:
        Player.players[1].moveFB(0);
        break;
      case 65:
        Player.players[1].rotateLR(0);
        break;
      case 68:
        Player.players[1].rotateLR(0);
        break;
        
      case 16:
        Player.players[0].mass += 1;
        break;
      case 17:
        Player.players[0].beamRadius += 0.01F;
        break;
      default:
        break;     
    }
  } catch (ArrayIndexOutOfBoundsException e) {
    return;
  }
}

/*
 * Game Setup
 */

void setup () {
  // Load color hashmap
  Cube.colours[0] = new Color(255, 255, 255); // WHITE, 0
  Cube.colours[1] = new Color(128, 128, 128); // GREY, 1
  Cube.colours[2] = new Color( 32,  32,  32); // DARKGREY, 2
  Cube.colours[3] = new Color(255,   0,   0); // RED, 3
  Cube.colours[4] = new Color(  0,   0, 255); // BLUE, 4
  Cube.colours[5] = new Color(  0, 255,   0); // GREEN, 5
  Cube.colours[6] = new Color(255, 255,   0); // YELLOW, 6
  
  Cube.cubeAmount = this.cubeAmount;
  Player.playerAmount = this.playerAmount;
  Cube.p = this;
  Player.p = this;
    
  size(1280, 720, P3D);
  frameRate(60);
  textSize(32);
  smooth(8);
  
  if (playerAmount == 1) {
    new Player(width / 2, height / 2, 0, 0, new Color(255, 0, 0));
  } else if (playerAmount == 2) {
    new Player(width / 4, height / 2, 0, 0, new Color(255, 0, 0));
    new Player(3 * width / 4, height / 2, 0, 1, new Color(0, 0, 255));
  } else if (playerAmount == 3) {
    new Player(width / 4, height / 4, 0, 0, new Color(255, 0, 0));
    new Player(3 * width / 4, height / 4, 0, 1, new Color(0, 0, 255));
    new Player(width / 4, 3 * height / 4, 0, 2, new Color(0, 255, 0));
  } else if (playerAmount == 4) {
    new Player(width / 4, height / 4, 0, 0, new Color(255, 0, 0));
    new Player(3 * width / 4, height / 4, 0, 1, new Color(0, 0, 255));
    new Player(width / 4, 3 * height / 4, 0, 2, new Color(0, 255, 0));
    new Player(3 * width / 4, 3 * height / 4, 0, 3, new Color(0, 255, 255));
  } else {
    print("Too many players!");
  }
  
  minim = new Minim( this );
  music = minim.loadFile( "play.mp3", 1024 );
  music.loop();
  
  for (int i = 0; i < initCubes; i++) {
    float rand = random(0, 100);
    float x = random(0, width);
    float y = random(0, height);
    if (rand > 99) {
      //Cube.cubes.add(new Cube(x, y, Cube.WHITE, 1));
    } else if (rand > 96) {
      Cube.cubes.add(new Cube(x, y, Cube.BLUE, 1));
    } else if (rand > 94) {
      Cube.cubes.add(new Cube(x, y, Cube.GREEN, 1));
    } else if (rand > 90) {
      Cube.cubes.add(new Cube(x, y, Cube.YELLOW, 1));
    } else if (rand > 75) {
      Cube.cubes.add(new Cube(x, y, Cube.GREY, 2));
    } else if (rand > 35) {
      Cube.cubes.add(new Cube(x, y, Cube.DARKGREY, 3));
    } else {
      Cube.cubes.add(new Cube(x, y, Cube.RED, 4));
    }
  }
}

void draw () {  
  background(32);
  
  if (frameCount == 1) {
  
    background = createGraphics(width, height);
    
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        float nv = noise(float(i) / 500.0, float(j) / 500.0);
        color c = color(255, 0, 255, nv*128);
        background.set(i, j, c);
      }
    }
  
  }
  
  image(background, 0, 0);
  
  translate(0, 0, 20);
  
  lights();
  
  //text(/*Player.players[0].dir*/frameRate, 20, height - 20);
  
  for (Player p : Player.players) {
    if (p == null) continue;
    p.update();
    p.draw();
  }
  
  for (Cube c : Cube.cubes) {
    if (c == null) continue;
    c.update();
    c.draw();
  }
}
