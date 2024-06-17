class PlantyFloor extends CollidableObject{
  float x, y, w, h;
  PImage[] growthSprites;
  PImage[] growthSpritesCarrot;
  PImage[] growthSpritesPlum;
  PImage[] growthSpritesCanabis;
  PImage defaultSprite;
  PImage spriteSheet = loadImage("spritesheet.png");
  PImage defaultImageNotGrowing = spriteSheet.get(224, 32, 32, 32);
  int currentStage;
  int totalStages;
  int lastUpdateTime;
  boolean isGrowing = false;
  String state = "Vazio";
  boolean isColliding = false;
  String plantyName = "Tomate";

  PlantyFloor(float x, float y, float w, float h, PImage defaultSprite, PImage[] growthSprites, PImage[] growthSpritesCarrot,PImage[] growthSpritesPlum,PImage[] growthSpritesCanabis) {
     super(new CollisionMask(0, 0, 32, 32, 32, 32));
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.defaultSprite = defaultSprite;
    this.growthSprites = growthSprites;
    this.growthSpritesCarrot = growthSpritesCarrot;
    this.growthSpritesPlum = growthSpritesPlum;
    this.growthSpritesCanabis = growthSpritesCanabis;
    this.totalStages = growthSprites.length;
    this.currentStage = 0;
    this.lastUpdateTime = millis();
    this.isGrowing = false;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  void setDefaultSprite(PImage sprite){
     this.defaultSprite = sprite;
  }
  
  String getState(){
      return this.state;
  }
  
  void setState(String newState){
       this.state = newState;
  }
  void setIsColliding(boolean colid){
      this.isColliding = colid;
  }
  
  boolean getIsColliding(){
    return true;
  }
  
   boolean getNoIsColliding(){
    return false;
  }
  
  void setIsGrowing(boolean value){
      this.isGrowing = value;
  }
  boolean getIsGrowing(){
      return this.isGrowing;
  }
  
  void setPlantyName(String name){
    this.plantyName = name;

  }
  
  String getPlantyName(){
    return this.plantyName;

  }


  void update() {
    // Verifica se é hora de atualizar a sprite
    int elapsedTime = millis() - lastUpdateTime;
    if (elapsedTime > 1000 && isGrowing) { // 60000 milissegundos = 1 minuto
      currentStage++;
      if (currentStage >= totalStages-1) {
        currentStage = totalStages - 1; // Garante que não ultrapasse o número total de estágios
        reset();
      }
      lastUpdateTime = millis();
    }
  }
  
  void reset() {
    if(this.plantyName.equals("Tomate")){
        this.currentStage = 0;
        this.state = "Pronto Para Coletar"; 
        this.isGrowing = false;
        if(state == "Pronto Para Coletar"){
          defaultSprite = defaultImageNotGrowing;
        }
    }else if(this.plantyName.equals("Cenoura")){
     this.currentStage = 0;
        this.state = "Pronto Para Coletar Cenoura"; 
        this.isGrowing = false;
        if(state == "Pronto Para Coletar Cenoura"){
          defaultSprite = defaultImageNotGrowing;
        }
    }else if(this.plantyName.equals("Ameixa")){
     this.currentStage = 0;
        this.state = "Pronto Para Coletar Ameixa"; 
        this.isGrowing = false;
        if(state == "Pronto Para Coletar Ameixa"){
          defaultSprite = defaultImageNotGrowing;
        }
    }else if(this.plantyName.equals("Canabis")){
     this.currentStage = 0;
        this.state = "Pronto Para Coletar Canabis"; 
        this.isGrowing = false;
        if(state == "Pronto Para Coletar Canabis"){
          defaultSprite = defaultImageNotGrowing;
        }
    }
    }

  void display() {
    update();
    getCollisionMask().updatePosition(x, y);
    // Desenhar a máscara de colisão
        getCollisionMask().display();
    // Exibe a sprite correspondente ao estágio atual de crescimento ou a sprite padrão se não estiver crescendo
    if(this.plantyName.equals("Tomate")){
    if (isGrowing) {
      image(growthSprites[currentStage], x, y, w, h);
    } else {
      image(defaultSprite, x, y, w, h);
    }
  }else if(this.plantyName.equals("Cenoura")){
  if (isGrowing) {
      image(growthSpritesCarrot[currentStage], x, y, w, h);
    } else {
      image(defaultSprite, x, y, w, h);
    }
  }else if(this.plantyName.equals("Ameixa")){
  if (isGrowing) {
      image(growthSpritesPlum[currentStage], x, y, w, h);
    } else {
      image(defaultSprite, x, y, w, h);
    }
  }else if(this.plantyName.equals("Canabis")){
  if (isGrowing) {
      image(growthSpritesCanabis[currentStage], x, y, w, h);
    } else {
      image(defaultSprite, x, y, w, h);
    }
  }
  }
  }
