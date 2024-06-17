class InventoryItem {
    String name;
    int quantity;
    PImage image;
    int value = 100;
    boolean selected; 
    static final int ITEM_SIZE = 50;

    InventoryItem(String name, int quantity, int value, PImage image) {
        this.name = name;
        this.quantity = quantity;
        this.image = image;
        this.value = value;
        this.selected = false;
    }
    
    PImage getImage(){
      return this.image;
      
    }
    
    int getQuantity(){
      return this.quantity;
      
    }
    
    void increaseQuantity(){
      this.quantity++;
    }
    
    void decreaseQuantity(){
      this.quantity--;
    }
    
    String getName(){
      return this.name;
    }
    
    int getValue(){
      
      return this.value;
    }
    
     boolean equals(InventoryItem other) {
        // Verifica se as imagens dos itens são iguais
        return this.image == other.getImage();
    }
    
     // Setter para marcar/desmarcar o item como selecionado
    void setSelected(boolean selected) {
        this.selected = selected;
    }

    // Getter para verificar se o item está selecionado
    boolean isSelected() {
        return selected;
    }
    
    void display(float x, float y) {
        image(image, x, y, ITEM_SIZE, ITEM_SIZE);
        if (selected) {
            // Desenha um contorno branco ao redor do item selecionado
            stroke(255);
            noFill();
            rect(x, y, ITEM_SIZE, ITEM_SIZE);
        }
    }
}
