public class Tile {
  
  public color texture;
  public PVector pos;

  public Tile(PVector pos) {
    this.pos = pos;
    texture = color(32, noise((pos.x + 30) * 1000, (pos.y + 30) * 1000) * 192 + 63, 32);
  }
  
  public Tile(int x, int y) {
    this(new PVector(x, y));
  }
  
  public void draw() {
    fill(texture);
    rect(pos.x * GRID_SIZE, pos.y * GRID_SIZE, GRID_SIZE, GRID_SIZE);
  }
  
}
