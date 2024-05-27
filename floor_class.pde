class Floor {
  float x, y, w, h;
  PImage floorImage;

  Floor(float x, float y, float w, float h, PImage floorImage) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.floorImage = floorImage;
  }

  void display() {
    image(floorImage, x, y, w, h);
  }
}
