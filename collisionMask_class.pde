class CollisionMask {
  float x, y, w, h; // Posição e dimensões da máscara de colisão
  float offsetX, offsetY; // Deslocamento da máscara em relação ao objeto
  float objectW, objectH; // Dimensões do objeto para centralizar a máscara

  CollisionMask(float offsetX, float offsetY, float w, float h, float objectW, float objectH) {
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    this.w = w;
    this.h = h;
    this.objectW = objectW;
    this.objectH = objectH;
    updatePosition(0, 0);
  }

  // Atualiza a posição da máscara de colisão
  void updatePosition(float objectX, float objectY) {
    this.x = objectX + offsetX + (objectW - w) / 2;
    this.y = objectY + offsetY + (objectH - h) / 2;
  }

  // Verifica a colisão com outra máscara de colisão
  boolean collidesWith(CollisionMask other) {
    return this.x < other.x + other.w &&
           this.x + this.w > other.x &&
           this.y < other.y + other.h &&
           this.y + this.h > other.y;
  }

  // Desenha a máscara de colisão (para depuração)
  void display() {
    noFill();
    stroke(255, 0, 0); // Cor vermelha
    rect(x, y, w, h);
  }
}
