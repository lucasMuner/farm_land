class Player extends CollidableObject {
    boolean moving = false;
    float x, y, size, speed;
    PImage seedImage;
    PImage waterImage;
    PImage tomatoImage;
    PImage plantyEmptyInteractyImage;
    PImage plantyEmptyImage;
    PImage plantySeedImage;
    PImage plantySeedInteractyImage;
    PImage plantySeedWetImage;
    PImage plantySeedWetInteractyImage;
    PImage plantyCollect;
    PImage plantyCollectInteract;
    PImage carrotImage;
    PImage carrotSeedImage;
    PImage carrotSeedInteractyImage;
    PImage carrotSeedWetImage;
    PImage carrotSeedWetInteractyImage;
    PImage carrotCollect;
    PImage carrotCollectInteract;
    PImage plumImage;
    PImage plumSeedImage;
    PImage plumSeedInteractyImage;
    PImage plumSeedWetImage;
    PImage plumSeedWetInteractyImage;
    PImage plumCollect;
    PImage plumCollectInteract;
    PImage canabisImage;
    PImage canabisSeedImage;
    PImage canabisSeedInteractyImage;
    PImage canabisSeedWetImage;
    PImage canabisSeedWetInteractyImage;
    PImage canabisCollect;
    PImage canabisCollectInteract;
    PImage[] walkRightFrames;
    PImage[] walkLeftFrames;
    PImage[] walkDownFrames;
    PImage[] walkUpFrames;
    int currentFrame;
    int frameCount;
    int animationSpeed;
    int lastFrameTime;
    String lastDirection ="";
    PImage img;
    PImage spriteAnimate;
    boolean up, down, left, right, interact;
    boolean canInteractWithPit = false;
    boolean pitEmpty = true;
    public int qtdTomatoSeeds = 0;
    public int qtdWater = 0;
    int lastInteractTime = 0; 
    int interactCooldown = 5000;
    Inventory inventory;
    boolean playerIsCollidingWithPlanty = false;
    PlantyFloor collidingPlantyFloor = null;
    boolean canInteractWithStore = true;
    int dayFilterColor = color(255, 255, 255, 255); // Filtro de cor para o dia (sem efeito)
    int nightFilterColor = color(30, 30, 30, 150); // Filtro de cor para a noite (escurecido)
    int money;
    
    Player(float x, float y, float size, float speed, PImage spriteSheet, PImage spriteAnimate, Inventory inventory, int startingMoney) {
        super(new CollisionMask(0, 22, size - 15, size - 45, size, size));
        this.x = x;
        this.y = y;
        this.size = size;
        this.speed = speed;
        this.img = spriteSheet;
        this.spriteAnimate = spriteAnimate;
        this.inventory = inventory;
        this.money = startingMoney;

        // Carregar os frames da animação
        frameCount = 7;
        animationSpeed = 100; // Velocidade da animação em milissegundos
        walkRightFrames = new PImage[frameCount];
        walkLeftFrames = new PImage[frameCount];
        walkDownFrames = new PImage[frameCount];
        walkUpFrames = new PImage[frameCount];
        
        seedImage = spriteAnimate.get(480, 0, 32, 32);
        waterImage = spriteAnimate.get(448, 0, 32, 32);
        tomatoImage = spriteAnimate.get(512, 0, 32, 32);
        plantyEmptyInteractyImage = spriteAnimate.get(224, 96, 32, 32);
        plantyEmptyImage = spriteAnimate.get(224, 32, 32, 32);
        plantySeedImage = spriteAnimate.get(224, 64, 32, 32);
        plantySeedInteractyImage = spriteAnimate.get(256, 96, 32, 32);
        plantySeedWetImage = spriteAnimate.get(256, 64, 32, 32);
        plantyCollect = spriteAnimate.get(384,64, 32, 32);
        plantyCollectInteract = spriteAnimate.get(288, 96, 32, 32);
        
        carrotImage = spriteAnimate.get(512, 32, 32, 32);
        carrotSeedImage = spriteAnimate.get(512, 64, 32, 32);
        carrotSeedInteractyImage = spriteAnimate.get(512, 96, 32, 32);
        carrotSeedWetImage = spriteAnimate.get(544, 32, 32, 32);
        carrotSeedWetInteractyImage = spriteAnimate.get(512, 96, 32, 32);
        carrotCollect = spriteAnimate.get(672,64, 32, 32);
        carrotCollectInteract = spriteAnimate.get(544, 96, 32, 32);
        
        plumImage = spriteAnimate.get(544, 32, 32, 32);
        plumSeedImage = spriteAnimate.get(512, 128, 32, 32);
        plumSeedInteractyImage = spriteAnimate.get(512, 160, 32, 32);
        plumSeedWetImage = spriteAnimate.get(544, 128, 32, 32);
        plumSeedWetInteractyImage = spriteAnimate.get(544, 160, 32, 32);
        plumCollect = spriteAnimate.get(672,128, 32, 32);
        plumCollectInteract = spriteAnimate.get(544, 160, 32, 32);
        
        canabisImage = spriteAnimate.get(576, 32, 32, 32);
        canabisSeedImage = spriteAnimate.get(512, 192, 32, 32);
        canabisSeedInteractyImage = spriteAnimate.get(512, 224, 32, 32);
        canabisSeedWetImage = spriteAnimate.get(544, 192, 32, 32);
        canabisSeedWetInteractyImage = spriteAnimate.get(544, 224, 32, 32);
        canabisCollect = spriteAnimate.get(672,192, 32, 32);
        canabisCollectInteract = spriteAnimate.get(544, 224, 32, 32);

        for (int i = 0; i < frameCount; i++) {
            walkRightFrames[i] = spriteAnimate.get(i * 32, 64, 32, 32);
            walkLeftFrames[i] = spriteAnimate.get(i * 32, 96, 32, 32);
            walkDownFrames[i] = spriteAnimate.get(i * 32, 0, 32, 32);
            walkUpFrames[i] = spriteAnimate.get(i * 32 + 224, 0, 32, 32);
        }

        currentFrame = 0;
        lastFrameTime = 0;
    }

    void updateAnimation() {
        if (millis() - lastFrameTime > animationSpeed) {
            currentFrame = (currentFrame + 1) % frameCount;
            lastFrameTime = millis();
        }
    }

    void move(ArrayList<Wall> walls, ArrayList<Wall> wallsDown, ArrayList<Wall> wallsTopLeft, ArrayList<Wall> wallsTopRight, ArrayList<Wall> wallsDownLeft, ArrayList<Wall> wallsDownRight, ArrayList<PlantyFloor> planty, ArrayList<Pit> pits, ArrayList<Seed> seeds, ArrayList<Tomato> tomatos, ArrayList<NpcStore> npcWody) {
     if (shop.isVisible) {
            // Jogador não pode se mover enquanto a loja está aberta
            return;
        }
      
      float newX = x;
     float newY = y;

    if (up) newY -= speed;
    if (down) newY += speed;
    if (left) newX -= speed;
    if (right) newX += speed;

    // Verificar colisão antes de atualizar a posição
    CollidableObject collidingObjectPlanty = getCollidingObject(planty);
    if (collidingObjectPlanty != null) {
        PlantyFloor plantyFloor = (PlantyFloor) collidingObjectPlanty;
        String plantyState = plantyFloor.getState();
        if (plantyState.equals("Vazio")) {
            plantyFloor.setDefaultSprite(plantyEmptyInteractyImage);
           if(inventory.getSelectedItemName().equals("Semente de Tomate")){ 
            if(player.interact && inventory.getItemQuantity("Semente de Tomate") > 0){
              plantyFloor.setDefaultSprite(plantySeedImage);
              plantyFloor.setState("Com Semente");
              inventory.removeItem("Semente de Tomate");
              this.interact = false;
            }
            }else if(inventory.getSelectedItemName().equals("Semente de Cenoura")){
                if(player.interact && inventory.getItemQuantity("Semente de Cenoura") > 0){
              plantyFloor.setDefaultSprite(carrotSeedImage);
              plantyFloor.setState("Com Semente de Cenoura");
              inventory.removeItem("Semente de Cenoura");
              this.interact = false;
            }
           }
           else if(inventory.getSelectedItemName().equals("Semente de Ameixa")){
                if(player.interact && inventory.getItemQuantity("Semente de Ameixa") > 0){
              plantyFloor.setDefaultSprite(plumSeedImage);
              plantyFloor.setState("Com Semente de Ameixa");
              inventory.removeItem("Semente de Ameixa");
              this.interact = false;
            }
           }else if(inventory.getSelectedItemName().equals("Semente de Canabis")){
                if(player.interact && inventory.getItemQuantity("Semente de Canabis") > 0){
              plantyFloor.setDefaultSprite(canabisSeedImage);
              plantyFloor.setState("Com Semente de Canabis");
              inventory.removeItem("Semente de Canabis");
              this.interact = false;
            }
           }
        }else if(plantyState.equals("Com Semente")){
            plantyFloor.setDefaultSprite(plantySeedInteractyImage);
            plantyFloor.setPlantyName("Tomate");
            if(player.interact && inventory.getItemQuantity("Água") > 0){
               plantyFloor.setDefaultSprite(plantySeedWetImage);
               plantyFloor.setState("Com Semente e Molhado");
               inventory.removeItem("Água");
               this.interact = false;
            }
        }else if(plantyState.equals("Com Semente e Molhado")){
               plantyFloor.setIsGrowing(true);
               this.interact = false;
        }else if(plantyState.equals("Pronto Para Coletar")){
               plantyFloor.setDefaultSprite(plantyCollectInteract);
            if(player.interact){
               plantyFloor.setDefaultSprite(plantyEmptyImage);
               this.interact = false;
               plantyFloor.setState("Vazio");
               collectTomato();
            }
        }else if(plantyState.equals("Com Semente de Cenoura")){
            plantyFloor.setDefaultSprite(carrotSeedInteractyImage);
            plantyFloor.setPlantyName("Cenoura");
            if(player.interact && inventory.getItemQuantity("Água") > 0){
               plantyFloor.setDefaultSprite(carrotSeedWetImage);
               plantyFloor.setState("Com Semente de Cenoura e Molhado");
               inventory.removeItem("Água");
               this.interact = false;
            }
        }else if(plantyState.equals("Com Semente de Cenoura e Molhado")){
               plantyFloor.setIsGrowing(true);
               this.interact = false;
        }else if(plantyState.equals("Pronto Para Coletar Cenoura")){
               plantyFloor.setDefaultSprite(carrotCollectInteract);
            if(player.interact){
               plantyFloor.setDefaultSprite(plantyEmptyImage);
               this.interact = false;
               plantyFloor.setState("Vazio");
               collectCarrot();
            }
        }else if(plantyState.equals("Com Semente de Ameixa")){
            plantyFloor.setDefaultSprite(plumSeedInteractyImage);
            plantyFloor.setPlantyName("Ameixa");
            if(player.interact && inventory.getItemQuantity("Água") > 0){
               plantyFloor.setDefaultSprite(plumSeedWetImage);
               plantyFloor.setState("Com Semente de Ameixa e Molhado");
               inventory.removeItem("Água");
               this.interact = false;
            }
        }else if(plantyState.equals("Com Semente de Ameixa e Molhado")){
               plantyFloor.setIsGrowing(true);
               this.interact = false;
        }else if(plantyState.equals("Pronto Para Coletar Ameixa")){
               plantyFloor.setDefaultSprite(plumCollectInteract);
            if(player.interact){
               plantyFloor.setDefaultSprite(plantyEmptyImage);
               this.interact = false;
               plantyFloor.setState("Vazio");
               collectPlum();
            }
        }else if(plantyState.equals("Com Semente de Canabis")){
            plantyFloor.setDefaultSprite(canabisSeedInteractyImage);
            plantyFloor.setPlantyName("Canabis");
            if(player.interact && inventory.getItemQuantity("Água") > 0){
               plantyFloor.setDefaultSprite(canabisSeedWetImage);
               plantyFloor.setState("Com Semente de Canabis e Molhado");
               inventory.removeItem("Água");
               this.interact = false;
            }
        }else if(plantyState.equals("Com Semente de Canabis e Molhado")){
               plantyFloor.setIsGrowing(true);
               this.interact = false;
        }else if(plantyState.equals("Pronto Para Coletar Canabis")){
               plantyFloor.setDefaultSprite(canabisCollectInteract);
            if(player.interact){
               plantyFloor.setDefaultSprite(plantyEmptyImage);
               this.interact = false;
               plantyFloor.setState("Vazio");
               collectCanabis();
            }
        }
        playerIsCollidingWithPlanty = plantyFloor.getIsColliding();
    } else {
        // Não há colisão com nenhum PlantyFloor, portanto, redefinimos o estado
        playerIsCollidingWithPlanty = false;
        // Limpa a referência ao PlantyFloor colidido anteriormente
        collidingPlantyFloor = null;

        // Atualiza a sprite de interação apenas para o PlantyFloor anteriormente colidido
        if (collidingPlantyFloor != null) {
            String plantyState = collidingPlantyFloor.getState();
            if (plantyState.equals("Vazio")) {
                collidingPlantyFloor.setDefaultSprite(plantyEmptyImage);
            }
        }
    }

    // Verificar todos os PlantyFloor
    if (!playerIsCollidingWithPlanty) {
        for (PlantyFloor plantyFloor : planty) {
            String plantyState = plantyFloor.getState();
            if (plantyState.equals("Vazio")) {
                plantyFloor.setDefaultSprite(plantyEmptyImage);
            }else if(plantyState.equals("Com Semente")){
               plantyFloor.setDefaultSprite(plantySeedImage);
            }else if(plantyState.equals("Pronto Para Coletar")){
               plantyFloor.setDefaultSprite(plantyCollect);
            }else if(plantyState.equals("Com Semente de Cenoura")){
               plantyFloor.setDefaultSprite(carrotSeedImage);
            }else if(plantyState.equals("Pronto Para Coletar Cenoura")){
               plantyFloor.setDefaultSprite(carrotCollect);
            }else if(plantyState.equals("Com Semente de Ameixa")){
               plantyFloor.setDefaultSprite(plumSeedImage);
            }else if(plantyState.equals("Pronto Para Coletar Ameixa")){
               plantyFloor.setDefaultSprite(plumCollect);
            }else if(plantyState.equals("Com Semente de Canabis")){
               plantyFloor.setDefaultSprite(canabisSeedImage);
            }else if(plantyState.equals("Pronto Para Coletar Canabis")){
               plantyFloor.setDefaultSprite(canabisCollect);
            }
            plantyFloor.setIsColliding(false); // Define como não colidindo
        }
    }
    
    
    CollidableObject collidingObjectPit = getCollidingObject(pits);
    if (collidingObjectPit != null) {
        // Faça algo com o objeto colidido, por exemplo, imprimir uma mensagem
         print("Colidiu com uma poço!");
    }
    
    CollidableObject collidingObjectWody = getCollidingObject(npcWody);
    if (collidingObjectWody != null) {
        // Faça algo com o objeto colidido, por exemplo, imprimir uma mensagem
         print("Colidiu com Wody!");
    }
    
    CollidableObject collidingObjectSeed = getCollidingObject(seeds);
    if (collidingObjectSeed != null) {
        collectSeed();
        seeds.remove(collidingObjectSeed);
        int seed = this.getQtdTomatoSeeds();
        print(seed);
    }


        // Verificar colisão antes de atualizar a posição
        getCollisionMask().updatePosition(newX, newY);
        if (!collidesWithWalls(walls) && 
            !collidesWithWalls(wallsDown) && 
            !collidesWithWalls(wallsTopLeft) &&
            !collidesWithWalls(wallsTopRight) &&
            !collidesWithWalls(wallsDownLeft) &&
            !collidesWithWalls(wallsDownRight) &&
            !collidesWithPit(pits) &&
            !collidesWithNpc(npcWody)
            ) {
            x = newX;
            y = newY;
        }
        
        
         for (NpcStore npc : npcWody) {
        if (npc.isPlayerNearby(this) && interact && canInteractWithStore) {
             shop.show();
             npc.setSprite(1);
             canInteractWithStore = false;
             lastInteractTime = millis();
        }
        
        if (!canInteractWithStore && millis() - lastInteractTime >= 2000 && npc.getContnAnim()) {
            canInteractWithStore = true;
         }
        }
        
         for (NpcStore npc : npcWody) {
        if (npc.isPlayerNearby(this) && canInteractWithStore){
              npc.setContnAnim(false);
              npc.setSprite(3);
              
        }else{
              npc.setContnAnim(true);
        }
          
        }
        
        
         for (Pit pit : pits) {
        if (pit.isPlayerNearby(this) && canInteractWithPit){
              
              pit.setSprite(2);
        }else if(!pit.isPlayerNearby(this) && canInteractWithPit){
          pit.setSprite(1);
        }
          
        }
        
        for (Pit pit : pits) {
        if (pit.isPlayerNearby(this) && interact && canInteractWithPit) {
            int water = this.getQtdWater();
            collectWater();
            print(water);
            pit.setSprite(0);
            pit.display();
            canInteractWithPit = false;
            lastInteractTime = millis();
        }
        if (!canInteractWithPit && millis() - lastInteractTime >= interactCooldown) {
            canInteractWithPit = true;
            pit.setSprite(1);
            pit.display();
        }
        
    }
    }

    boolean collidesWithWalls(ArrayList<Wall> walls) {
        for (Wall wall : walls) {
            if (getCollisionMask().collidesWith(wall.getCollisionMask())) {
                return true;
            }
        }
        return false;
    }
    
    boolean collidesWithPit(ArrayList<Pit> pits) {
        for (Pit pit : pits) {
            if (getCollisionMask().collidesWith(pit.getCollisionMask())) {
                return true;
            }
        }
        return false;
    }
    
     boolean collidesWithNpc(ArrayList<NpcStore> npcs) {
        for (NpcStore npc : npcs) {
            if (getCollisionMask().collidesWith(npc.getCollisionMask())) {
                return true;
            }
        }
        return false;
    }
    CollidableObject getCollidingObject(ArrayList<? extends CollidableObject> objects) {
    for (CollidableObject obj : objects) {
        if (obj != this && getCollisionMask().collidesWith(obj.getCollisionMask())) {
            return obj; // Retorna o objeto com o qual houve colisão
        }
    }
    return null; // Retorna null se não houver colisão com nenhum objeto
}


    void display() {
        updateAnimation();
        PImage currentImage = null; // Inicializa como nulo

        // Define a imagem atual com base na direção do movimento
        if (right) {
            currentImage = walkRightFrames[currentFrame];
            updateLastDirection();
        } else if (left) {
            currentImage = walkLeftFrames[currentFrame];
            updateLastDirection();
        } else if (down) {
            currentImage = walkDownFrames[currentFrame];
            updateLastDirection();
        } else if (up) {
            currentImage = walkUpFrames[currentFrame];
            updateLastDirection();
        } else {
            // Se não estiver se movendo, exibe a última direção de movimento
            if (lastDirection.equals("right")) {
                currentImage = walkRightFrames[0];
            } else if (lastDirection.equals("left")) {
                currentImage = walkLeftFrames[6];
            } else if (lastDirection.equals("down")) {
                currentImage = walkDownFrames[0];
            } else if (lastDirection.equals("up")) {
                currentImage = walkUpFrames[0];
            }
        }

        // Se ainda não houver uma imagem definida, use a imagem padrão
        if (currentImage == null) {
            currentImage = img;
        }

        // Exibe a imagem atual
        image(currentImage, x, y, size, size);

        // Desenhar a máscara de colisão
        getCollisionMask().display();
    }

    // Método para atualizar a última direção de movimento
    void updateLastDirection() {
        if (right) {
            lastDirection = "right";
        } else if (left) {
            lastDirection = "left";
        } else if (down) {
            lastDirection = "down";
        } else if (up) {
            lastDirection = "up";
        }
    }

void keyPressed() {
    if (key == 'w') up = true;
    if (key == 's') down = true;
    if (key == 'a') left = true;
    if (key == 'd') right = true;
    if (key == 'e') interact = true;
    else if (key == ESC) {
        if (shop.isVisible) {
            shop.hide();
            key = 0; // Previne que a tela de pause padrão apareça
        }
    }

    checkMoving();
}

void keyReleased() {
    if (key == 'w') up = false;
    if (key == 's') down = false;
    if (key == 'a') left = false;
    if (key == 'd') right = false;
    if (key == 'e') interact = false;

    checkMoving();
}

void checkMoving() {
    if (up || down || left || right) {
        moving = true;
    } else {
        moving = false;
    }
}

        void mousePressed() {
        if (shop.isVisible) {
            shop.checkMouseClick(mouseX + cameraX, mouseY + cameraY);
        }
    }
    
    int getQtdTomatoSeeds(){
      return ++qtdTomatoSeeds;
      
    }
    int getQtdWater(){
      return ++qtdWater;
      
    }
    
    void collectSeed() {
    InventoryItem seed = new InventoryItem("Semente de Tomate", 1,0, seedImage);
    inventory.addItem(seed);
    }
    void collectWater() {
    InventoryItem water = new InventoryItem("Água", 1,0, waterImage);
    inventory.addItem(water);
    }
     void collectTomato() {
    InventoryItem tomato = new InventoryItem("Tomate", 1,200, tomatoImage);
    inventory.addItem(tomato);
    }
    void collectCarrot() {
    InventoryItem carrot = new InventoryItem("Cenoura", 1, 400, carrotImage);
    inventory.addItem(carrot);
    }
    
    void collectPlum() {
    InventoryItem plum = new InventoryItem("Ameixa", 1, 500, plumImage);
    inventory.addItem(plum);
    }
    
    void collectCanabis() {
    InventoryItem canabis = new InventoryItem("Canabis", 1, 1000, canabisImage);
    inventory.addItem(canabis);
    }
    
   void setInteract(boolean value){
       this.interact = value;
   }
    void addMoney(int amount) {
        this.money += amount;
    }

    void subtractMoney(int amount) {
        this.money -= amount;
    }

    int getMoney() {
        return money;
    }
    
    boolean isMoving() {
    return moving;
   }
   

}
