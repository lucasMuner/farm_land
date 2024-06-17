class ShopItem {
    PImage image;
    String name;
    int price;
    boolean isMouse = false;
    boolean isClicked = false;
    PImage hoverImage; // Imagem quando o mouse está sobre o botão
    PImage clickedImage; // Imagem quando o item é clicado

    float x, y, width, height;

    ShopItem(String name, int price, PImage image, PImage hoverImage, PImage clickedImage) {
        this.name = name;
        this.price = price;
        this.image = image;
        this.hoverImage = hoverImage;
        this.clickedImage = clickedImage;
    }

    void setPosition(float x, float y, float width, float height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    boolean isMouseOver(float mouseX, float mouseY) {
        return mouseX > this.x && mouseX < this.x + width && mouseY > this.y && mouseY < this.y + height;
    }

    void display() {
        // Desenha a imagem de fundo do botão
        if (isMouse) {
            image(hoverImage, x, y, width, height + 20); // Imagem quando o mouse está sobre o botão
        } else {
            image(buttonBackground, x, y, width, height + 20); // Imagem de fundo padrão do botão
        }

        // Desenha a imagem do item
        image(image, x + (width - 100) / 2, y + (height - 100) / 2, 100, 100);

        // Texto do nome do item
        fill(0);
        textAlign(CENTER);
        textSize(12);
        text(name, x + width / 2, y + height - 10);

        textSize(12);
        text("Preço: " + price, x + width / 2, y + height + 2);

        // Verifica se o item está clicado para mostrar a imagem de clique
        if (isClicked) {
            image(clickedImage, x, y, width, height + 20); // Imagem quando o item é clicado
        }
    }
}
