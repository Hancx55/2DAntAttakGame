class Explosion {

  color colour = color(200, 0, 0);
  float x, y;
  PImage images[] = new PImage[5];
  PImage image;
  int frame = 0;
  boolean done = false;

  Explosion(float x, float y, color c) {
    // for ants and bee
    this.x = x;
    this.y = y;
    this.colour = c;

    for (int i = 0; i<images.length; i++) {
      images[i] = loadImage("explosion" + (i+1) + ".png");
    }
  }

  //fire ants explode - overloading
  Explosion(float x, float y) {
    this.x = x;
    this.y = y;

    for (int i = 0; i<images.length; i++) {
      images[i] = loadImage("explosion" + (i+1) + ".png");
    }
  }

  void display() {
    if (frame < 50) {
      int i = frame/10;
      tint(colour);
      image(images[i], x, y);
      frame += 1;
    }
  }
}
