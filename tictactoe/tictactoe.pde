/* tic tac toe */

Square[][] board = new Square[3][3];
int currentPlayer = 1;
color player1;
color player2;
boolean won = false;
boolean botOpponent = true;

Bot bot;

  
final int[][][] wins = {
  {{0, 0}, {0, 1}, {0, 2}},
  {{1, 0}, {1, 1}, {1, 2}},
  {{2, 0}, {2, 1}, {2, 2}},
  {{0, 0}, {1, 0}, {2, 0}},
  {{0, 1}, {1, 1}, {2, 1}},
  {{0, 2}, {1, 2}, {2, 2}},
  {{0, 0}, {1, 1}, {2, 2}},
  {{2, 0}, {1, 1}, {0, 2}}    
};

void setup() {
  
  size(600, 600);
  colorMode(HSB, 255);
  smooth(8);
  
  player1 = color(256, 128, 255);
  player2 = color(128, 128, 255);
  
  if (botOpponent) {
    
    bot = new Bot();
    
  }
  
  for (int i = 0; i < 3; i++) {
    
    for (int j = 0; j < 3; j++) {
      
      board[i][j] = new Square(i, j);
      
    }
    
  }
  
  background(32);
  drawBoard();
  
}

void draw() {
  
  if (!won && botOpponent && currentPlayer == 2) {
    
    bot.doTurn();
    
    drawBoard();
    checkWin();
    
  }
  
}

void drawBoard() {
  
  for (int i = 0; i < 3; i++) {
    
    for (int j = 0; j < 3; j++) {
      
      board[i][j].draw();
      
    }
    
  }
  
}

void mousePressed() {
  
  if (won) {
    
    reset();
    drawBoard();
    return;
    
  }
  
  for (int i = 0; i < 3; i++) {
    
    for (int j = 0; j < 3; j++) {
      
      board[i][j].activate(currentPlayer, mouseX, mouseY);
      
    }
    
  }
  
  drawBoard();
  
  checkWin();
  
}

void reset() {
  
  won = false;
  currentPlayer = 1;
  
  for (int i = 0; i < 3; i++) {
    
    for (int j = 0; j < 3; j++) {
      
      board[i][j] = new Square(i, j);
      
    }
    
  }
  
  background(32);
  
}

void switchPlayer() {
  
  currentPlayer++;
  if (currentPlayer > 2) currentPlayer = 1;
  
}

Square getSq(int x, int y) {
  
  return board[x][y];
  
}

Square getSq(int[] pos) {
  
  return getSq(pos[0], pos[1]);
  
}

boolean checkLine(int[] s1, int[] s2, int[] s3) {
  
  int p1 = getSq(s1).player;
  if (p1 == 0) return false;
  return p1 == getSq(s2).player && p1 == getSq(s3).player;
  
}

void checkWin() {
  
  if (won) return;
  
  for (int[][] row : wins) {
    
    if (checkLine(row[0], row[1], row[2])) {
      
      switchPlayer();
      
      println("Player " + currentPlayer + " wins!");
      
      stroke(255);
      strokeWeight(5);
      
      Square s1 = getSq(row[0]);
      Square s2 = getSq(row[2]);
      
      line(s1.centreX(), s1.centreY(), s2.centreX(), s2.centreY());
      
      won = true;
      
    }
    
  }
  
  for (int i = 0; i < 3; i++) {
    
    for (int j = 0; j < 3; j++) {
      
      if (getSq(i, j).player == 0)
        return;
      
    }
    
  }
  
  println("The game was a tie!");
  
  won = true;
  
}

String oPair(int[] a) {
 
 return "(" + a[0] + ", " + a[1] + ")";
  
}

class Square {
  
  boolean empty = true;
  int player;
  
  int x, y;
  int sx, sy;
  int ex, ey;
  
  Square(int x, int y) {
    
    this.x = x;
    this.y = y;
    
    sx = x * width / 3;
    sy = y * height / 3;
    
    ex = (x + 1) * width / 3;
    ey = (y + 1) * height / 3;
    
  }
  
  float centreX() {
    
    return (sx + ex) / 2;
    
  }
  
  float centreY() {
    
    return (sy + ey) / 2;
    
  }
  
  void activate(int player, int mx, int my) {
    
    if (mx < sx || my < sy || mx >= ex || my >= ey || this.player != 0)
      return;
      
    this.player = player;
    
    switchPlayer();
    
  }
  
  void activate(int player) {
    
    if (this.player != 0) return;
    
    this.player = player;
    switchPlayer();
    
  }
  
  void draw() {
    
    noFill();
    stroke(255);
    strokeWeight(5);
    
    rect(sx, sy, width / 3, height / 3);
    
    if (player == 1) {
      
      stroke(player1);
      strokeWeight(10);
      
      line(sx + width / 12, sy + height / 12, ex - width / 12, ey - height / 12);
      line(sx + width / 12, ey - height / 12, ex - width / 12, sy + height / 12);   
      
    } else if (player == 2) {
      
      stroke(player2);
      strokeWeight(10);

      ellipse(centreX(), centreY(), width / 6, height / 6);      
      
    }
    
  }
  
}

class Bot {
  
  int[] missingSpot(int[] s1, int[] s2, int[] s3) {
    
    int p1 = getSq(s1).player;
    int p2 = getSq(s2).player;
    int p3 = getSq(s3).player;
    
    if (p1 == p2 && p1 != 0 && p3 == 0) {
      
      return s3;
      
    } else if (p2 == p3 && p2 != 0 && p1 == 0) {
      
      return s1;
      
    } else if (p1 == p3 && p1 != 0 && p2 == 0) {
      
      return s2;
      
    } else {
      
      return new int[]{-1, -1};
      
    }
    
  }
  
  int[] nextMove() {
    
    for (int[][] row : wins) {
      
      int[] spot = missingSpot(row[0], row[1], row[2]);
      
      if (spot[0] != -1) {
        
        //println("ai : " + oPair(spot));
        //println("     from row: " + oPair(row[0]) + " to "
        //    + oPair(row[2])); 
        return spot;
        
      }
      
    }
    
    if (getSq(1, 1).player == 0) {
      
      //println("ai : centre");
      return new int[]{1, 1};
      
    }
    
    //println("ai : random");
    return new int[]{int(random(3)), int(random(3))};
    
  }
  
  void select(int[] position) {
    
    getSq(position).activate(currentPlayer);
    
  }
  
  void doTurn() {
    
    select(nextMove());
    
  }
  
}
