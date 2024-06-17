class Shop {
    ArrayList<ShopItem> items;
    boolean isVisible;
    Inventory inventory;
    Player player;
    PImage moneyIcon;
    PImage sellButtonImage; // Imagem do botão de vender

    Shop(Inventory inventory, Player player, PImage moneyIcon, PImage sellButtonImage) {
        items = new ArrayList<>();
        isVisible = false;
        this.inventory = inventory;
        this.player = player;
        this.moneyIcon = moneyIcon;
        this.sellButtonImage = sellButtonImage;
    }

    void addItem(ShopItem item) {
        items.add(item);
    }

    void display(float cameraX, float cameraY) {
    if (!isVisible) return;

    float shopX = cameraX + width / 2 - (width - 100) / 2;
    float shopY = cameraY + height / 2 - (height - 100) / 2;

    image(shopBackground, shopX + 100, shopY + 100, width - 300, height - 280); // Desenha a imagem de fundo

    int cols = 2; // Número de colunas de itens
    int rows = 2; // Número de linhas de itens
    int buttonSize = 120; // Tamanho dos botões
    int spacing = 20;
    float startX = shopX + (width - 300 - (cols * buttonSize + (cols - 1) * spacing)) / 2;
    float startY = shopY + (height - 100 - (rows * buttonSize + (rows - 1) * spacing)) / 2;

    for (int i = 0; i < items.size(); i++) {
        float x = startX + (i % cols) * (buttonSize + spacing);
        float y = startY + (i / cols) * (buttonSize + spacing);

        ShopItem item = items.get(i);
        item.setPosition(x, y, buttonSize, buttonSize);

        item.display();
    }

    // Desenha o quadrado adicional no lado direito
    float additionalBoxX = shopX + width - 400; // Posição X do quadrado adicional
    float additionalBoxY = shopY + 100 + spacing; // Posição Y do quadrado adicional

    image(buttonBackground, additionalBoxX, additionalBoxY, 175, height - 280 - 2 * spacing);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("FarmCoins", additionalBoxX + 90, additionalBoxY + 30);
    textSize(25);
    text(player.getMoney() + "x", additionalBoxX + 70, additionalBoxY + 140); // Exibe o dinheiro do jogador

    // Desenha a imagem ao lado do texto do dinheiro
    image(moneyIcon, additionalBoxX + 95, additionalBoxY + 115, 48, 48); // Posição e tamanho da imagem do dinheiro

    // Desenha o botão de vender
    image(sellButtonImage, additionalBoxX + 40, additionalBoxY + 250, 100, 40);

    // Adiciona o texto "Vender" no meio do botão de vender
    fill(255); // Cor branca para o texto
    textSize(18); // Tamanho da fonte do texto
    textAlign(CENTER, CENTER);
    text("Vender", additionalBoxX + 90, additionalBoxY + 270); // Posição centralizada no botão de vender
}


    void show() {
        isVisible = true;
    }

    void hide() {
        isVisible = false;
    }

    void checkMouseHover(float mouseX, float mouseY) {
        if (!isVisible) return;
        for (ShopItem item : items) {
            item.isMouse = item.isMouseOver(mouseX, mouseY);
        }
    }

   void checkMouseClick(float mouseX, float mouseY) {
    if (!isVisible) return;
        float shopX = cameraX + width / 2 - (width - 100) / 2;
        float shopY = cameraY + height / 2 - (height - 100) / 2;
    // Verifica se o botão de vender foi clicado
    float additionalBoxX = shopX + width - 400 - 10; // Posição X do quadrado adicional
    float additionalBoxY = shopY + 100 + 110; // Posição Y do quadrado adicional
    float buttonWidth = 100;
    float buttonHeight = 40;

    // Calcula as coordenadas do botão de vender
    float buttonX = additionalBoxX + 50; // Início do botão de vender
    float buttonY = additionalBoxY + 160; // Ajuste vertical para posicionar corretamente o botão de vender



    // Verifica se o mouse está dentro das coordenadas do botão de vender
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth &&
        mouseY > buttonY && mouseY < buttonY + buttonHeight) {
        sellItems();
        // Desenha um retângulo para visualizar a área de clique do botão de vender
        fill(100,100,100);
        noStroke(); // Cor vermelha para o retângulo
        rect(buttonX, buttonY, buttonWidth, buttonHeight);
        println("Clicou no botão de vender!");
        // Mensagem para verificar no console se o clique foi registrado
        return;
    }

    // Verifica se algum item da loja foi clicado
    for (ShopItem item : items) {
        if (item.isMouseOver(mouseX, mouseY)) {
            if (player.getMoney() >= item.price) {
                addItemToInventory(item);
                player.subtractMoney(item.price);
                item.isClicked = true;
            } else {
                println("Dinheiro insuficiente!");
            }
            break;
        }
    }
}



    
      void setPlayer(Player player) {
        this.player = player;
    }

    void addItemToInventory(ShopItem item) {
        inventory.addItem(new InventoryItem(item.name, 1, 0, item.image));
    }
    
     void sellItems() {
        ArrayList<String> itemNamesToSell = new ArrayList<>();
        itemNamesToSell.add("Tomate");
        itemNamesToSell.add("Cenoura");
        itemNamesToSell.add("Ameixa");
        itemNamesToSell.add("Canabis");
         ArrayList<InventoryItem> itemsToRemove = new ArrayList<>();
    for (InventoryItem item : inventory.items) {
        if (itemNamesToSell.contains(item.getName())) {
            player.addMoney(item.getValue());
            itemsToRemove.add(item);
        }
    }

    for (InventoryItem item : itemsToRemove) {
        inventory.removeItem(item.getName()); // Remove pelo nome do item
        print("vendeu");
    }
    }
}
