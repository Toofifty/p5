final int BLOCK_SIZE = 250;

Paddle paddle;
Ball ball;
Block b;
boolean gameover = false;

void setup() {
  
  size(800, 500);
  colorMode(HSB, 255);
  noStroke();
  paddle = new Paddle(width / 2, height - 50);
  ball = new Ball(width / 2, height / 2);
  b = new Block(width / 2, height / 3, BLOCK_SIZE, true);
  
}

void draw() {
  
  fill(32, 32);
  rect(0, 0, width, height);
  paddle.update();
  ball.update();
  ball.collide(paddle);
  paddle.draw();
  ball.draw();
  
  b.collide(ball);
  b.draw();  
  
}

void restart() {
  
  paddle = new Paddle(width / 2, height - 50);
  ball = new Ball(width / 2, height / 2);
  gameover = false;
  
}

void keyPressed() {
  
  switch(keyCode) {
    
  case 39:
    paddle.dir = 1;
    break;
    
  case 37:
    paddle.dir = -1;
    break; 
    
  }
  
}

void keyReleased() {
  
  switch(keyCode) {
    
  case 39:
  case 37:
    paddle.dir = 0;
    break;
    
  } 
  
}
