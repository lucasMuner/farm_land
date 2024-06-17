class NpcStore extends CollidableObject{
  float x, y, w, h;
  CollisionMask collisionMask;
  int swapSprite = 0;
  PImage[] listSprite = new PImage[4];
  int currentStage = 0;
  int lastUpdateTime = millis();
  int totalStages = 4;
  boolean continueAnimation = false;
   
  
  NpcStore(float x, float y, float w, float h, float collisionOffsetX, float collisionOffsetY, float collisionWidth, float collisionHeight, PImage[] listSprite) {
    super(new CollisionMask(collisionOffsetX, collisionOffsetY, collisionWidth, collisionHeight, w, h));
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.listSprite = listSprite;

    
    getCollisionMask().updatePosition(x, y);
  }
  
  
  void update() {
    // Verifica se é hora de atualizar a sprite
    int elapsedTime = millis() - lastUpdateTime;
    if (elapsedTime > 1000 && continueAnimation) { // 60000 milissegundos = 1 minuto
      currentStage++;
      if (currentStage >= totalStages-1) {
        currentStage = totalStages - 1; // Garante que não ultrapasse o número total de estágios
        reset();
      }
      lastUpdateTime = millis();
    }
  }
  
  void reset() {
        this.currentStage = 0;
    }
  
   void setSprite(int value){
       this.currentStage = value;
       
    }
  
    int getSprite(){
       return this.swapSprite;
    }
    
    boolean getContnAnim(){
       return this.continueAnimation;
    }
    
    void setContnAnim(boolean newStatus){
       this.continueAnimation = newStatus;
    }
  
  
  void display() {
    update();
    image(listSprite[currentStage], x, y, w, h);
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
