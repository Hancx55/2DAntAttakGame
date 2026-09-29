//class ants inherits enemy
class Ants extends Enemy
{
  Ants()
  {
    super();
    speed =  (int)random(1, 2);

    velocity = getVelocity(target);
    points = 5;

    for (int i = 0; i < 3; i++)
    {
      for (int a = 0; a < 8; a++) {
        //2d array of all ant frames in each direction
        images[i][a] = loadImage("ant" + (i+1) + (a+1) + ".png");
      }
    }
  }

  //overriding
  void update()
  {
    display();
    move();
  }
}
