class Player extends CollidableObject {
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
    
    Player(float x, float y, float size, float speed, PImage spriteSheet, PImage spriteAnimate, Inventory inventory) {
        super(new CollisionMask(0, 22, size - 15, size - 45, size, size));
        this.x = x;
        this.y = y;
        this.size = size;
        this.speed = speed;
        this.img = spriteSheet;
        this.spriteAnimate = spriteAnimate;
        this.inventory = inventory;

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

    void move(ArrayList<Wall> walls, ArrayList<Wall> wallsDown, ArrayList<Wall> wallsTopLeft, ArrayList<Wall> wallsTopRight, ArrayList<Wall> wallsDownLeft, ArrayList<Wall> wallsDownRight, ArrayList<PlantyFloor> planty, ArrayList<Pit> pits, ArrayList<Seed> seeds, ArrayList<Tomato> tomatos) {
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
            if(player.interact){
              plantyFloor.setDefaultSprite(plantySeedImage);
              plantyFloor.setState("Com Semente");
              this.interact = false;
            }
        }else if(plantyState.equals("Com Semente")){
            plantyFloor.setDefaultSprite(plantySeedInteractyImage);
            if(player.interact){
               plantyFloor.setDefaultSprite(plantySeedWetImage);
               plantyFloor.setState("Com Semente e Molhado");
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
            }
            plantyFloor.setIsColliding(false); // Define como não colidindo
        }
    }
    
    
    CollidableObject collidingObjectPit = getCollidingObject(pits);
    if (collidingObjectPit != null) {
        // Faça algo com o objeto colidido, por exemplo, imprimir uma mensagem
         print("Colidiu com uma poço!");
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
            !collidesWithPit(pits)
            ) {
            x = newX;
            y = newY;
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
    }

    void keyReleased() {
        if (key == 'w') up = false;
        if (key == 's') down = false;
        if (key == 'a') left = false;
        if (key == 'd') right = false;
        if (key == 'e') interact = false;
    }
    
    int getQtdTomatoSeeds(){
      return ++qtdTomatoSeeds;
      
    }
    int getQtdWater(){
      return ++qtdWater;
      
    }
    
    void collectSeed() {
    InventoryItem seed = new InventoryItem("Semente de Tomate", 1, seedImage);
    inventory.addItem(seed);
    }
    void collectWater() {
    InventoryItem water = new InventoryItem("Água", 1, waterImage);
    inventory.addItem(water);
    }
     void collectTomato() {
    InventoryItem tomato = new InventoryItem("Tomate", 1, tomatoImage);
    inventory.addItem(tomato);
    }
    
   void setInteract(boolean value){
       this.interact = value;
   }
   
   
}
