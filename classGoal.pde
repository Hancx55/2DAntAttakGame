//goal for enemies to reach
class Goal
{
  int x, y;
  int size;
  PImage imagelife[] = new PImage[4]; // array for cake displayed depending on lives
  PImage noCake;
  int life = 1000;

  PVector position = new PVector(250, 250);

  //constructor
  Goal(int x, int y)
  {
    this.x = x;
    this.y = y;
    size = 100;
    for (int i = 0; i<4; i++)
    {
      imagelife[i] = loadImage("cakelife" + i + ".png"); // loading each frame
    }
    noCake = loadImage("noCake.png");
  }

  void update()
  {
    display();
    displayhealthBar();
  }

  void display()
  {
    imageMode(CENTER); // centering images
    if (life>0) {
      int i = life / 250;
      if (i>3) i = 3;
      image(imagelife[i], x, y);
    } else {
      image(noCake, x, y);
    }
  }

  void displayhealthBar() {

    textSize(18);
    fill(255, 0, 0);
    text("CAKE HEALTH", 20, 20);
    text(life/10 + "%", 130, 20);

    if (life>=0) {
      rectMode(CORNER);
      rect(20, 20, life*0.45, 10);
    }
  }

  void goalReached(float num)
  {
    //will decrease health depending on num of enemies on goal
    if (life>0) {
      num = num/100;
      life -= num;
    } else life = 0;
  }

  boolean gameEnd() {
    if (life <= 0) return true;
    else return false;
  }
}
