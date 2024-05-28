class InventoryItem {
    String name;
    int quantity;
    PImage image;

    InventoryItem(String name, int quantity, PImage image) {
        this.name = name;
        this.quantity = quantity;
        this.image = image;
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
    
     boolean equals(InventoryItem other) {
        // Verifica se as imagens dos itens são iguais
        return this.image == other.getImage();
    }
}
