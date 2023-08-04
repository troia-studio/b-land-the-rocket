class Platform {
  PVector pos;
  int w;
  int h;
  
  Platform(PVector pos, int w, int h) {
    this.pos = pos;
    this.w = w;
    this.h = h;
  }
  
  void show() {
    beginShape();
    fill(170);
    vertex(pos.x - w * 0.5, pos.y - h * 0.5 );
    fill(200);
    vertex(pos.x + w * 0.5, pos.y - h * 0.5 );
    fill(100);
    vertex(pos.x + w * 0.5, pos.y + h * 0.5);
    fill(70);
    vertex(pos.x - w * 0.5, pos.y + h * 0.5);
    endShape();
  }
}
