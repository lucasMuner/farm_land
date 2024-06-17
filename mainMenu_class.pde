class MainMenu {
  PImage bg;
  PImage easyImage, mediumImage, hardImage, farmLandLogo;
  String title = "Farm Land";
  String[] menuItems = {"Play", "Instructions", "Credits"};
  float[] angles = {0, 0, 0};  // Ângulos para o efeito de gangorra
  float angleSpeed = 0.1;  // Velocidade da gangorra
  PFont font8bit;
  int selectedItem = -1;  // -1 significa nenhum item selecionado
  boolean gameStarted = false;
  int difficulty = 0;  // 0: fácil, 1: médio, 2: difícil
  String difficultyText;

  MainMenu() {
      farmLandLogo = loadImage("farm land logo.png");
      bg = loadImage("background.jpg");
      bg.resize(width, height);
      easyImage = loadImage("easy.png");
      mediumImage = loadImage("medium.png");
      hardImage = loadImage("hard.png");
      easyImage.resize(200, 200);  // Ajustar a escala das imagens
      mediumImage.resize(200, 200);
      hardImage.resize(200, 200);
      farmLandLogo.resize(400, 200);
      font8bit = createFont("8bitFont.TTF", 36);
      textFont(font8bit);
      textAlign(CENTER, CENTER);
      textSize(36);
  }

  void display() {
    background(bg);
    image(farmLandLogo, width / 2 - farmLandLogo.width / 2, 50);
    if (selectedItem == -1) {
      fill(0);
      textSize(48);
      // Sombreamento
      text(title, width / 2 + 2, height / 4 + 2);
      fill(139, 69, 19);  // Cor marrom clarinho
      text(title, width / 2, height / 4);  // Desenhar o título
  
      textSize(36);
      for (int i = 0; i < menuItems.length; i++) {
        float x = width / 2;
        float y = height / 2 + i * 100;  // Aumentar o espaçamento vertical
  
        // Verificar se o mouse está sobre o item de menu
        if (mouseX > x - 220 && mouseX < x + 220 && mouseY > y - 30 && mouseY < y + 30) {
          angles[i] += angleSpeed;  // Aumentar o ângulo para o efeito de gangorra
          if (angles[i] > PI / 8) {
            angles[i] = PI / 8;
          }
        } else {
          angles[i] -= angleSpeed;  // Diminuir o ângulo para o efeito de gangorra
          if (angles[i] < 0) {
            angles[i] = 0;
          }
        }
  
        // Desenhar o item de menu com rotação
        pushMatrix();
        translate(x, y);
        rotate(sin(angles[i]) * PI / 8);
        fill(255);
        stroke(0);
        strokeWeight(3);
        rectMode(CENTER);
        rect(0, 0, 440, 60, 10);  // Retângulo com bordas arredondadas e largura aumentada
        fill(0);
        noStroke();
        text(menuItems[i], 0, 0);
        popMatrix();
      }
    } else if (selectedItem == 0) {  // Play
      fill(0, 150);  // Semi-transparente
      rectMode(CENTER);
      rect(width / 2, height / 2 - 70, 600, 400);
      PImage img;
     
      if (difficulty == 0) {
        img = easyImage;
        difficultyText = "Easy";

      } else if (difficulty == 1) {
        img = mediumImage;
        difficultyText = "Medium";
        player.setDifficulty(1);
        player.setMoney(100);
      } else {
        img = hardImage;
        difficultyText = "Hard";
        player.setDifficulty(2);
        player.setMoney(50);
      }
      image(img, width / 2 - img.width / 2, height / 2 - img.height / 2 - 120);
      fill(255);
      text(difficultyText, width / 2, height / 2 + 30);
      fill(255, 0, 0);
      triangle(width / 2 - 200, height / 2, width / 2 - 180, height / 2 - 20, width / 2 - 180, height / 2 + 20);
      triangle(width / 2 + 200, height / 2, width / 2 + 180, height / 2 - 20, width / 2 + 180, height / 2 + 20);
      
      // Botão Play dentro do Play
      fill(255);
      stroke(0);
      strokeWeight(3);
      rect(width / 2, height - 150, 240, 50, 10);  // Retângulo com bordas arredondadas
      fill(0);
      noStroke();
      text("Play", width / 2, height - 150);
      
      // Botão Voltar
      drawBackButton();
    } else if (selectedItem == 1) {  // Instructions
      fill(0, 150);  // Semi-transparente
      rectMode(CENTER);
      rect(width / 2, height / 2, 600, 400);
      fill(255);
      textSize(24);
      textAlign(CENTER, CENTER);  // Alinhar ao centro
      text("INSTRUCTIONS\n \nawsd to move \ne to interact", width / 2, height / 2, 560, 200);  // Centralizar texto
      
      // Botão Voltar
      drawBackButton();
    } else if (selectedItem == 2) {  // Credits
      fill(0, 150);  // Semi-transparente
      rectMode(CENTER);
      rect(width / 2, height / 2, 600, 400);
      fill(255);
      textSize(24);
      textAlign(CENTER, CENTER);  // Alinhar ao centro
      text("Collaborators\n \nLucas Muner \nMatheus Negretti \nRenan Couto \nSamuel Dias", width / 2, height / 2, 560, 200);  // Centralizar texto
      
      // Botão Voltar
      drawBackButton();
    }
  }
  void drawBackButton() {
    fill(255);
    stroke(0);
    strokeWeight(3);
    rectMode(CENTER);
    rect(width / 2, height - 50, 240, 50, 10);  // Retângulo com bordas arredondadas
    fill(0);
    noStroke();
    text("Back", width / 2, height - 50);
  }
  void mousePressed() {
    if (selectedItem == -1) {
      for (int i = 0; i < menuItems.length; i++) {
        float x = width / 2;
        float y = height / 2 + i * 100;  // Aumentar o espaçamento vertical
        if (mouseX > x - 220 && mouseX < x + 220 && mouseY > y - 30 && mouseY < y + 30) {
          selectedItem = i;
          break;
        }
      }
    } else {
      // Verificar se o botão "Voltar" foi clicado
      if (mouseX > width / 2 - 120 && mouseX < width / 2 + 120 && mouseY > height - 75 && mouseY < height - 25) {
        selectedItem = -1;
         player.setDifficulty(0);
         player.setMoney(200);
      } else if (selectedItem == 0) {  // Play
        if (mouseX > width / 2 - 220 && mouseX < width / 2 - 180 && mouseY > height / 2 - 20 && mouseY < height / 2 + 20) {
          difficulty = max(0, difficulty - 1);  // Decrease difficulty
        player.setDifficulty(1);
        player.setMoney(100);
        } else if (mouseX > width / 2 + 180 && mouseX < width / 2 + 220 && mouseY > height / 2 - 20 && mouseY < height / 2 + 20) {
          difficulty = min(2, difficulty + 1);  // Increase difficulty
          player.setDifficulty(2);
        player.setMoney(50);
        } else if (mouseX > width / 2 - 120 && mouseX < width / 2 + 120 && mouseY > height - 175 && mouseY < height - 125) {

          gameStarted = true;
          println("Iniciando o jogo na dificuldade: " + difficulty);
        }
      }
    }
  }
  
  int getDifficulty(){
    return this.difficulty;
  }
  
  void keyPressed() {
    if (key == 'b' || key == 'B') {
      selectedItem = -1;
    }
  }
}
