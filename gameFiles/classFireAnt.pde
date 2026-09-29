//class for enemy to be avoided by player
class FireAnt extends Enemy
{
  PImage image; // friendly enemy graphic

  float time;
  PVector temp;

  int state = 0; // 0=move 1=avoid

  //constructor method
  FireAnt()
  {
    super();
    this.size = 20;
    target = getRandomBorder();
    velocity = getVelocity(target);
    points = -10;
    enemyState = EnemyState.MOVING;


    for (int i = 0; i < 3; i++)
    {
      for (int a = 0; a < 8; a++) {
        //2d array of all fire ant frames in each direction
        images[i][a] = loadImage("fireant" + (i+1) + (a+1) + ".png");
      }
    }
  }

  //overriding
  void update()
  {
    move();
    display();
  }

  //overriding
  void move()
  {
    position.add(velocity); // movement
    checkDirection();

    if (position.x>550 || position.x<-50 || position.y>550 || position.y<-50) // resets movement if enemy off screen
    {
      target = getRandomBorder(); // start target
      velocity = getVelocity(target);
    }

    if (state == 1) // avoid
    {
      time -= 1; //avoid for 30 frames

      if (time<=0)
      {
        state=0; // moving
        velocity=temp; // original velocity regained
      }
    }
  }

  //overriding
  void targetHit(Goal other) // collision with Goal class
  {
    if (dist(this.position.x, this.position.y, other.x, other.y)<100 && state==0) // if fire ant too close to cake and isnt already avoiding
    {
      PVector around = PVector.sub(this.position, other.position); //creates vector between fireant + cake
      around.normalize();
      float angle = radians(90); // angle to move around

      if (((this.velocity.x*other.position.y)-(this.velocity.y*other.position.x)) < 0) // determines which way to turn
      {
        angle=-angle; // changes radians depending on which side the object is
      }

      around.rotate(angle);
      around.mult(2);
      temp = velocity; // creates temporary variable to hold original velocity
      velocity = around; // change velocity to allow for obj to move around
      state = 1; // avoiding
      time = 30; // avoids for 30 frames
    }
  }
}
