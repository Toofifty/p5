public class Camera {
  
  private float rotateX = -PI / 4;
  private float rotateY;
  private float rotateZ;
  
  public void updateRotate(float dx, float dy) {
    rotateX -= dy / 100F;
    rotateY += dx / 100F;
    if (rotateX > -PI / 4) rotateX = -PI / 4;
    if (rotateX < -PI / 2) rotateX = -PI / 2;
  }
  
  public void applyRotate() {
    rotateX(rotateX);
    rotateY(rotateY);
    rotateZ(rotateZ);
  }
  
}
