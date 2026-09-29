//class bee inherits enemy
class Bee extends Enemy
{
  PVector offset = new PVector(random(0, 500), random(0, 500));

  Bee()
  {
    super();
    speed =  (int)random(3, 4);

    velocity = getVelocity(offset);
    points = 10;

    for (int i = 0; i < 3; i++)
    {
      for (int a = 0; a < 8; a++) {
        //2d array of all bee frames in each direction
        images[i][a] = loadImage("bee" + (i+1) + (a+1) + ".png");
      }
    }
  }

  //overriding
  void update()
  {
    move();
    display();

    //when offset reached, move towards target
    if (dist(position.x, position.y, offset.x, offset.y) < 50)
    {
      velocity = PVector.sub(target, position);
      velocity.normalize();
      velocity.mult(speed);
      enemyState = EnemyState.MOVING;
    }
  }
}
