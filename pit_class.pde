class Pit extends CollidableObject{
  float x, y, w, h;
  PImage img;
  CollisionMask collisionMask;
  int swapSprite = 0;
  PImage[] listSprite = new PImage[2];
  
  Pit(float x, float y, float w, float h, float collisionOffsetX, float collisionOffsetY, float collisionWidth, float collisionHeight, PImage img, PImage[] listSprite) {
    super(new CollisionMask(collisionOffsetX, collisionOffsetY, collisionWidth, collisionHeight, w, h));
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
    this.listSprite = listSprite;
    
    getCollisionMask().updatePosition(x, y);
  }
  
  
  void setSprite(int value){
       this.swapSprite = value;
       
  }
  
  int getSprite(){
       return this.swapSprite;
  }
  
  
  
  void display() {
    image(listSprite[this.getSprite()], x, y, w, h);
    getCollisionMask().display();
  }
  
  boolean isPlayerNearby(Player player) {
        float proximityRange = 40; // Ajuste conforme necessário
        float playerCenterX = player.x + player.size / 2;
        float playerCenterY = player.y + player.size / 2;

        return playerCenterX > this.x - proximityRange && playerCenterX < this.x + this.w + proximityRange &&
               playerCenterY > this.y - proximityRange && playerCenterY < this.y + this.h + proximityRange;
    }
}
