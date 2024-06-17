class Inventory {
    ArrayList<InventoryItem> items;
    int selectedSlot; // Índice do item selecionado
    float displayX; // Posição X de exibição do inventário
    float displayY; // Posição Y de exibição do inventário

    Inventory() {
        items = new ArrayList<InventoryItem>(); // Lista de itens no inventário
        selectedSlot = -1; // Nenhum item selecionado inicialmente
        displayX = 0; // Inicializa a posição X de exibição
        displayY = height; // Inicializa a posição Y de exibição, abaixo da tela
    }

    // Método para adicionar um item ao inventário
    void addItem(InventoryItem newItem) {
        // Verifica se o item já está no inventário
        for (InventoryItem item : items) {
            // Se encontrarmos um item semelhante, aumentamos sua quantidade e saímos do método
            if (item.getName().equals(newItem.getName())) {
                item.increaseQuantity();
                return;
            }
        }
        // Se não houver um item semelhante, adicionamos o novo item ao inventário
        items.add(newItem);
    }

    // Método para selecionar um item com base na tecla pressionada
    void selectItem(int slotIndex) {
        if (slotIndex >= 0 && slotIndex < items.size()) {
            selectedSlot = slotIndex;
        }
    }

    // Método para deselecionar todos os itens
    void deselectAllItems() {
        selectedSlot = -1; // Nenhum item selecionado
    }

    // Método para obter o nome do item selecionado
    String getSelectedItemName() {
        if (selectedSlot != -1 && selectedSlot < items.size()) {
            return items.get(selectedSlot).getName();
        }
        return ""; // Retorna uma string vazia se nenhum item estiver selecionado
    }

    void removeItem(String itemName) {
        for (InventoryItem item : items) {
            if (item.getName().equals(itemName)) {
                if (item.getQuantity() > 1) {
                    item.decreaseQuantity();
                } else {
                    items.remove(item);
                }
                return;
            }
        }
    }

    void remove(InventoryItem item) {
        items.remove(item);
    }

    void removeQuantity(InventoryItem item) {
        item.decreaseQuantity();
    }

    public int getItemQuantity(String itemName) {
        for (InventoryItem item : items) {
            if (item.getName().equals(itemName)) {
                return item.getQuantity();
            }
        }
        return 0; // Retorna 0 se o item não estiver no inventário
    }

    void display() {
        float startX = 0 + displayX; // Posição X inicial do inventário ajustada pela variável displayX
        float startY = height + displayY; // Posição Y inicial do inventário ajustada pela variável displayY
        int slotSize = 50; // Tamanho do slot do inventário

        for (int i = 0; i < 7; i++) { // Desenha os slots do inventário
            fill(150, 75, 0);
            stroke(0);
            rect(startX + i * slotSize, startY, slotSize, slotSize);

            // Verifica se há um item neste slot
            if (i < items.size()) {
                // Obtém a quantidade de itens no slot
                InventoryItem item = items.get(i);
                int quantity = item.getQuantity();

                // Desenha a quantidade de itens no canto superior direito do slot
                pushStyle(); // Salva o estilo atual
                fill(255); // Cor do texto
                textAlign(RIGHT, TOP); // Alinhamento do texto
                textSize(12); // Tamanho da fonte
                text(quantity, startX + (i + 1) * slotSize - 5, startY + 5); // Posição do texto
                popStyle(); // Restaura o estilo anterior

                // Desenha um contorno branco ao redor do item selecionado
                if (i == selectedSlot) {
                    noFill();
                    stroke(255);
                    rect(startX + i * slotSize, startY, slotSize, slotSize);
                }
                PImage itemImage = item.getImage(); // Obtém a imagem do item
                image(itemImage, startX + i * slotSize, startY, slotSize, slotSize);
            }
        }
    }
}
