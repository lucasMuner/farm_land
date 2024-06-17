class Canabis extends CollidableObject{
  float x, y, w, h;
  PImage img;
  CollisionMask collisionMask;
  
  Canabis(float x, float y, float w, float h, float collisionOffsetX, float collisionOffsetY, float collisionWidth, float collisionHeight, PImage img) {
    super(new CollisionMask(collisionOffsetX, collisionOffsetY, collisionWidth, collisionHeight, w, h));
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
    
    getCollisionMask().updatePosition(x, y);
  }
  
  
  
  void display() {
    image(img, x, y, w, h);
    getCollisionMask().display();
  }
}
