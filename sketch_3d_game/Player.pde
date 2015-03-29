public class Player {
  
  private PVector pos;
  
  public Player() {
    pos = new PVector(0, 0, 0);
  }
  
  public void translateView() {
    translate(pos.x * 32, pos.y * 32, pos.z * 32);
  }
  
  public void moveN() {
    pos.x++;
  }
  
  public void moveE() {
    pos.y++;
  }
  
  public void moveW() {
    pos.y--;
  }
  
  public void moveS() {
    pos.x--;
  }
  
  public void setPos(int x, int y) {
    pos.x = x;
    pos.y = y;
  }
  
  public void translateBack() {
    translate(-pos.x * 32, -pos.y * 32, -pos.z * 32);
  }
  
  public void draw() {
    fill(255, 0, 0);
    translate(0, 0, 16);
    box(32);
  }
  
  public int getX() {
    return (int) pos.x;
  }
  
  public int getY() {
    return (int) pos.y;
  }
  
}
