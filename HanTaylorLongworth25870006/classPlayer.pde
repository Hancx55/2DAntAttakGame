class Player // playable character controlled by mouse
{
  int x, y;
  int score;
  PImage images[] = new PImage[4];
  boolean done = false;
  int index = 0;
  boolean pressed = false;

  Player(int x, int y)
  {
    this.x = x;
    this.y = y;
    score = 0;

    for (int i = 0; i < images.length; i++)
    {
      images[i] = loadImage("swat" + (i+1) + ".png");
    }
  }

  void update()
  {
    display();
    movement();
  }

  void display() //displays graphic
  {
    imageMode(CENTER);
    animation();

    fill(255, 255, 255);
    text("SCORE: " + score, 400, 20);
  }

  void movement()
  {
    x = mouseX;
    y = mouseY;
  }

  //bug swatting
  void animation() {
    if (mousePressed == true) {
      //swat animation
      pressed = true;
      done = false;
      index = 25;
    }
    if (done!=true && pressed == true) {
      image(images[index/25], x, y);
      index+=5;
      if (index > 99) {
        done = true;
        pressed = false;
      }
    } else image(images[0], x, y);
  }

  //collision with mouse
  boolean overEnemy(Enemy other)
  {
    if (x<=other.position.x+other.size && x>=other.position.x-other.size && y<=other.position.y+other.size && y>=other.position.y-other.size)
    {
      return true;
    } else return false;
  }

  //if cake clicked, kill eating ants
  boolean overGoal(Goal other)
  {
    if (x<other.position.x+other.size/3 && x>other.position.x-other.size/3 && y<other.position.y+other.size/3 && y>other.position.y-other.size/3)
    {
      return true;
    } else return false;
  }
}
