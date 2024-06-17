import processing.sound.*;

Player player;
Inventory inventory;
Shop shop;
MainMenu menu;
boolean gameStarted = false;
boolean gameWon = false;
boolean isMoving = false;
PImage spriteSheet;
PImage wallImage;
PImage wallDownImage;
PImage wallTopLeftImage;
PImage wallTopRightImage;
PImage wallDownLeftImage;
PImage wallDownRightImage;
PImage plantyFloorDefault;
PImage seedImage;
PImage pitImage;
PImage shopBackground;
PImage moneyIcon;
PImage[] plantyFloorGrowing = new PImage[6];
PImage[] carrotFloorGrowing = new PImage[6];
PImage[] plumFloorGrowing = new PImage[6];
PImage[] canabisFloorGrowing = new PImage[6];
PImage[] pitsAnimate = new PImage[3];
PImage[] npcStoreImages = new PImage[2];
PImage[] npcStoreAnimate = new PImage[4];
PImage playerImage;
PImage layoutImage;
PImage floorImage;
int wallSize = 32; 
int scale = 2;
int playerSize = 32;
int speed = 3;
int scaleLayout = 40; // Escala do layoutsd
int rows = 16; // Número de linhas no layout
int cols = 20; 
float cameraX, cameraY;
PImage buttonBackground;
int horas = 20;

ArrayList<NpcStore> npcWody;
ArrayList<Wall> walls;
ArrayList<Wall> wallsDown;
ArrayList<Wall> wallsTopLeft;
ArrayList<Wall> wallsTopRight;
ArrayList<Wall> wallsDownRight;
ArrayList<Wall> wallsDownLeft;
ArrayList<Floor> floors;
ArrayList<PlantyFloor> plantyFloors;
ArrayList<Pit> pits;
ArrayList<Seed> seeds;
ArrayList<Tomato> tomatos;

SoundFile music;
SoundFile walk;

void setup() {
  size(800, 640);
  inventory = new Inventory();
  menu = new MainMenu();
  spriteSheet = loadImage("spritesheet.png");
  layoutImage = loadImage("layout.png");
  layoutImage.resize(cols, rows); // Redimensiona a imagem para o tamanho desejado
  shopBackground = loadImage("shop_background.png");
  buttonBackground = loadImage("item_shop_background.png");
  wallImage = spriteSheet.get(0, 32, wallSize, wallSize);
  wallDownImage = spriteSheet.get(64, 32, wallSize, wallSize);
  wallTopLeftImage = spriteSheet.get(96, 32, wallSize, wallSize);
  wallTopRightImage = spriteSheet.get(128, 32, wallSize, wallSize);
  wallDownLeftImage = spriteSheet.get(160, 32, wallSize, wallSize);
  wallDownRightImage = spriteSheet.get(192, 32, wallSize, wallSize);
  plantyFloorDefault = spriteSheet.get(224, 32, wallSize, wallSize);
  playerImage = spriteSheet.get(0, 0, playerSize-1, playerSize-1);
  npcStoreImages[0] = spriteSheet.get(0, 160, wallSize, wallSize);
  npcStoreImages[1] = spriteSheet.get(0, 192, wallSize, wallSize);
  floorImage = spriteSheet.get(32, 32, wallSize, wallSize);
  pitImage = spriteSheet.get(384,32,wallSize,wallSize);
  pitsAnimate[0] = spriteSheet.get(448,32,wallSize,wallSize);
  pitsAnimate[1] = spriteSheet.get(384,32,wallSize,wallSize);
  pitsAnimate[2] = spriteSheet.get(480,32,wallSize,wallSize);
  seedImage = spriteSheet.get(416,32,wallSize,wallSize);
  moneyIcon = spriteSheet.get(0,224,wallSize,wallSize);
  for(int i = 0; i < 6; i++){
     plantyFloorGrowing[i] = spriteSheet.get(256+i*32, 64, wallSize, wallSize);
  }
  
  for(int i = 0; i < 6; i++){
     carrotFloorGrowing[i] = spriteSheet.get(544+i*32, 64, wallSize, wallSize);
  }
  
  for(int i = 0; i < 6; i++){
     canabisFloorGrowing[i] = spriteSheet.get(544+i*32, 192, wallSize, wallSize);
  }
  
  for(int i = 0; i < 6; i++){
     plumFloorGrowing[i] = spriteSheet.get(544+i*32, 128, wallSize, wallSize);
  }
  
  for(int i = 0; i < 4; i++){
     npcStoreAnimate[i] = spriteSheet.get(i*32, 160, wallSize, wallSize);
  }
  PImage hoverImage = loadImage("item_shop_background_over.png");
  PImage clickedImage = loadImage("item_shop_background_click.png");

  shop = new Shop(inventory, player, moneyIcon,buttonBackground);
  PImage itemImage1 = spriteSheet.get(480,0,wallSize,wallSize);
  PImage itemImage2 = spriteSheet.get(544,0,wallSize,wallSize);
  PImage itemImage3 = spriteSheet.get(576,0,wallSize,wallSize);
  PImage itemImage4 = spriteSheet.get(608,0,wallSize,wallSize);

  shop.addItem(new ShopItem("Semente de Tomate", 100,itemImage1,hoverImage,clickedImage));
  shop.addItem(new ShopItem("Semente de Cenoura", 200,itemImage2,hoverImage,clickedImage));
  shop.addItem(new ShopItem("Semente de Ameixa", 300,itemImage3,hoverImage,clickedImage));
  shop.addItem(new ShopItem( "Semente de Canabis", 400,itemImage4,hoverImage,clickedImage));
  
  registerMethod("keyPressed", this);
  initializeGameObjects();
  
  music = new SoundFile(this, "farmland_soundtrack.mp3");
  walk = new SoundFile(this, "andando.mp3");

  music.loop();
  walk.loop();

}

void draw() {
  background(255); // Limpa a tela
  if(!gameStarted)
  {
    menu.display();
    gameStarted = menu.gameStarted;
  } else if (!gameWon) {
    updateCamera();
    renderGame();

    if (player != null && player.isMoving() && !walk.isPlaying()) {
      walk.loop();
    } else if (player != null && !player.isMoving() && walk.isPlaying()) {
      walk.stop();
    }

    // Verifica a condição de vitória
    if (player != null && player.getMoney() >= 2000) {
      gameWon = true;
      music.stop();
      walk.stop();
    }
  } else {
    // Tela de vitória
    fill(0, 0, 0, 150); // Fundo preto meio transparente
    rect(0, 0, width, height);
    
    textSize(32);
    fill(255); // Texto branco
    textAlign(CENTER, CENTER);
    text("Você ganhou o jogo!", width / 2, height / 2);
  }
}

void initializeGameObjects() {
  // Inicializando as listas de paredes e pisos
  walls = new ArrayList<Wall>();
  wallsDown = new ArrayList<Wall>();
  wallsTopLeft = new ArrayList<Wall>();
  wallsDownLeft = new ArrayList<Wall>();
  wallsTopRight = new ArrayList<Wall>();
  wallsDownRight = new ArrayList<Wall>();
  floors = new ArrayList<Floor>();
  plantyFloors = new ArrayList<PlantyFloor>();
  pits = new ArrayList<Pit>();
  seeds = new ArrayList<Seed>();
  tomatos = new ArrayList<Tomato>();
  npcWody = new ArrayList<NpcStore>();

  // Analisando o layout para determinar as paredes e o chão
  analyzeLayout();
}

void renderGame() {
  // Desenha os pisos
  for (Floor floor : floors) {
    floor.display();
  }
  for (PlantyFloor pFloor : plantyFloors) {
    pFloor.display();
  }
  for (Pit pit : pits) {
    pit.display();
  }
  for (Seed seed : seeds) {
    seed.display();
  }
  // Desenha as paredes
  for (Wall wall : walls) {
    wall.display();
  }
  for (Wall wall : wallsDown) {
    wall.display();
  }
  
  for (Wall wall : wallsTopLeft) {
    wall.display();
  }
  
  for (Wall wall : wallsTopRight) {
    wall.display();
  }
  
  for (Wall wall : wallsDownLeft) {
    wall.display();
  }
  for (Wall wall : wallsDownRight) {
    wall.display();
  }
  
  for (NpcStore npc : npcWody) {
   npc.display();
  }
    // Chame a função display() do player
  if (player != null) {
    player.move(walls, 
          wallsDown, 
          wallsTopLeft, 
          wallsTopRight, 
          wallsDownLeft, 
          wallsDownRight,
          plantyFloors,
          pits,
          seeds,
          tomatos,
          npcWody);
    player.display();
  }
  
  if (npcWody != null){
  
  }
  inventory.display();
  
  shop.display(cameraX, cameraY);
  shop.checkMouseHover(mouseX, mouseY);
}

void keyPressed() {
  // Chame a função keyPressed() do player
  if (player != null) {
    player.keyPressed();
  }
  if (key == '1') {
    inventory.selectItem(0); // Seleciona o primeiro item (índice 0)
  } else if (key == '2') {
    inventory.selectItem(1); // Seleciona o segundo item (índice 1)
  } else if (key == '3') {
    inventory.selectItem(2); // Seleciona o segundo item (índice 1)
  } else if (key == '4') {
    inventory.selectItem(3); // Seleciona o segundo item (índice 1)
  } else if (key == '5') {
    inventory.selectItem(4); // Seleciona o segundo item (índice 1)
  } else if (key == '6') {
    inventory.selectItem(5); // Seleciona o segundo item (índice 1)
  } else if (key == '7') {
    inventory.selectItem(6); // Seleciona o segundo item (índice 1)
  } 
}

void keyReleased() {
  // Chame a função keyReleased() do player
  if (player != null) {
    player.keyReleased();
  }
}

void mousePressed() {
  // Chame a função keyReleased() do player
  if(!gameStarted) {
    menu.mousePressed();
    
  } else if (player != null) {
    player.mousePressed();
  }
  
}

void mouseReleased() {
  // Chame a função keyReleased() do player
    for (ShopItem item : shop.items) {
        item.isClicked = false;
    }
}

void updateCamera() {
  if (player != null) {
    // Atualiza a posição da câmera para seguir o jogador
    cameraX = player.x + playerSize * scale / 2 - width / 2;
    cameraY = player.y + playerSize * scale / 2 - height / 2;
    
    // Limites da câmera
    float minCameraX = 0;
    float minCameraY = 0;
    float maxCameraX = cols * wallSize * scale - width;
    float maxCameraY = rows * wallSize * scale - height;
    
    // Restringe a posição da câmera dentro dos limites do mapa
    cameraX = constrain(cameraX, minCameraX, maxCameraX);
    cameraY = constrain(cameraY, minCameraY, maxCameraY);
    inventory.displayX = cameraX + width/4 + 25;
    inventory.displayY =cameraY - 75;
  }
  
  // Aplica a translação da câmera
  translate(-cameraX, -cameraY);
  if (shop.isVisible) {
    shop.display(cameraX, cameraY);
  }
}

void analyzeLayout() {
  layoutImage.loadPixels(); // Carrega os pixels da imagem para evitar interpolação

  // Converte as cores desejadas para comparar
  int black = color(0, 0, 0);
  int white = color(255, 255, 255);
  int playerColor = color(72, 0, 255);
  int downWall = color(255, 0, 0);
  int topLeftWall = color(0, 255, 0);
  int downLeftWall = color(230,120,0);
  int downRightWall = color(38,127,0);
  int topRightWall = color(255,0,110);
  int plantyF = color(127,89,63);
  int pitColor = color(255,216,0);
  int seedColor = color(0,255,255);
  int npcStoreColor = color(178,0,255);

  // Percorre os pixels da imagem do layout
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      // Obtém a cor do pixel na posição (x, y) do layoutImage
      int pixelColor = layoutImage.pixels[y * cols + x];
      
      // Verifica se o pixel corresponde à cor desejada
      if (pixelColor == black) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        walls.add(new Wall(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale,0,0,wallSize * scale,(wallSize-5) * scale, wallImage));
      }else if (pixelColor == downWall) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        wallsDown.add(new Wall(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale,0,0,(wallSize-24) * scale,wallSize * scale, wallDownImage));
      }else if (pixelColor == topLeftWall) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        wallsTopLeft.add(new Wall(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale,12,0,(wallSize-14) * scale,wallSize * scale, wallTopLeftImage));
      }else if (pixelColor == downLeftWall) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        wallsDownLeft.add(new Wall(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale,11,0,(wallSize-14) * scale,wallSize * scale, wallDownLeftImage));
      }else if (pixelColor == downRightWall) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        wallsDownRight.add(new Wall(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale,-11,0,(wallSize-14) * scale,wallSize * scale, wallDownRightImage));
      }
      else if (pixelColor == topRightWall) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        wallsTopRight.add(new Wall(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale,-11,0,(wallSize-14) * scale,wallSize * scale, wallTopRightImage));
      }
      else if (pixelColor == plantyF) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        plantyFloors.add(new PlantyFloor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, plantyFloorDefault, plantyFloorGrowing, carrotFloorGrowing,plumFloorGrowing,canabisFloorGrowing));
      }
      else if (pixelColor == pitColor) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        pits.add(new Pit(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale,0,6,wallSize * scale,(wallSize-12) * scale, pitImage, pitsAnimate));
      }
      else if (pixelColor == npcStoreColor) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        npcWody.add(new NpcStore(x * wallSize * scale, y * wallSize * scale, playerSize * scale, playerSize * scale,0,6,(wallSize-10) * scale,(wallSize-6) * scale, npcStoreAnimate));
      }
      else if (pixelColor == seedColor) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        seeds.add(new Seed(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale,0,0,wallSize * scale,(wallSize-5) * scale, seedImage));
      }
      else if (pixelColor == white) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
      } else if (pixelColor == playerColor) {
        floors.add(new Floor(x * wallSize * scale, y * wallSize * scale, wallSize * scale, wallSize * scale, floorImage));
        player = new Player(x * wallSize * scale, y * wallSize * scale, playerSize * scale, speed, playerImage, spriteSheet,inventory, 200);
        shop.setPlayer(player);
      }
    }
  }
}
