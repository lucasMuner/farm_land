class Inventory {
    ArrayList<InventoryItem> items;
    int selectedSlot;
    float displayX; // Posição X de exibição do inventário
    float displayY; // Posição Y de exibição do inventário

    Inventory() {
        items = new ArrayList<InventoryItem>(); // Lista de itens no inventário
        selectedSlot = 0; // slot selecionado inicialmente
        displayX = 0; // Inicializa a posição X de exibição
        displayY = height; // Inicializa a posição Y de exibição, abaixo da tela
    }

    // Método para adicionar um item ao inventário
    void addItem(InventoryItem newItem) {
    // Verifica se o item já está no inventário
    for (InventoryItem item : items) {
        // Se encontrarmos um item semelhante, aumentamos sua quantidade e saímos do método
        if (item.equals(newItem)) {
            item.increaseQuantity();
            return;
        }
    }
    
    // Se não houver um item semelhante, adicionamos o novo item ao inventário
    items.add(newItem);
}

     void removeItem(String itemName) {
        for (InventoryItem item : items) {
          if (item.getName().equals(itemName)) {
            if(item.getQuantity() > 1){
               item.decreaseQuantity();
            }else{
              items.remove(item);
            }
            return;
        }
        }
    }
    
     void remove(InventoryItem item) {
        items.remove(item);
    }
    
    void removeQtd(InventoryItem item) {
        item.decreaseQuantity();
    }

    void display() {
    float startX = 0 + displayX; // Posição X inicial do inventário ajustada pela variável displayX
    float startY = height + displayY; // Posição Y inicial do inventário ajustada pela variável displayY
    int slotSize = 50; // Tamanho do slot do inventário

    for (int i = 0; i < 7; i++) { // Desenha os slots do inventário
        fill(150,75,0);
        stroke(0);
        rect(startX + i * slotSize, startY, slotSize, slotSize);
        
        // Verifica se há um item neste slot
        if (i < items.size()) {
            // Obtém o item no slot atual
            InventoryItem item = items.get(i);
            
            // Obtém a quantidade de itens no slot
            int quantity = item.getQuantity();
            
            // Desenha a quantidade de itens no canto superior direito do slot
            pushStyle(); // Salva o estilo atuala
            fill(255); // Cor do texto
            textAlign(RIGHT, TOP); // Alinhamento do texto
            textSize(12); // Tamanho da fonte
            text(quantity, startX + (i + 1) * slotSize - 5, startY + 5); // Posição do texto
            popStyle(); // Restaura o estilo anterior
        }
    }
    
    // Desenha os itens do inventário nos slots
    for (int i = 0; i < items.size(); i++) {
        InventoryItem item = items.get(i);
        PImage itemImage = item.getImage(); // Obtém a imagem do item
        image(itemImage, startX + i * slotSize, startY, slotSize, slotSize);
    }
}

}
