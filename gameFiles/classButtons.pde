class Buttons {
  int x;
  int y;
  int size;
  color colour;
  String msg;

  Buttons(int x, int y, int s, color colour, String msg) {
    this.x = x;
    this.y = y;
    this.size = s + (msg.length()*5);
    this.colour = colour;
    this.msg = msg;
  }

  void display() {
    fill(colour);
    rectMode(CENTER);
    rect(x, y, size, size/3);

    textAlign(CENTER, CENTER);
    fill(0, 0, 0);
    text(msg, x, y);
    textAlign(LEFT, BASELINE);
  }

  boolean clicked() {
    if (mousePressed == true && mouseX > x-size/2 && mouseX < x+size/2 && mouseY > y-size/6 && mouseY < y+size/6) {
      return true;
    } else return false;
  }
}
