public class Map {

  public Tile[][] tiles;
  
  public Map(int size) {
    tiles = new Tile[size][size];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        tiles[i][j] = new Tile(i, j);
      }
    }
  }
  
  public void draw() {
    for (Tile[] row : tiles) {
      for (Tile tile : row) {
        tile.draw();
      }
    }
  }
  
}
