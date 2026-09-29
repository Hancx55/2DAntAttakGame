// enemy parent class
abstract class Enemy
{
  PVector position; // enemy location
  PVector velocity;
  PVector target = new PVector(250, 250);
  float speed; // enemy speed
  int size; // height and width
  PImage images[][] = new PImage[3][8]; // displays enemy graphic

  int points;
  int frame = 0;
  int time = 0;
  int direction;

  boolean checkedEating = false;

  EnemyState enemyState = EnemyState.MOVING;

  //constructor method
  Enemy()
  {
    //creates memory for object
    position = getRandomBorder();
    size = 20;
    speed = random(1, 2); //speed
  }

  void display()
  {
    //animation frames for images
    time += 1;
    if (time < 10) frame = 0;
    else if (time < 20) frame = 1;
    else if (time < 30) frame = 2;
    else time = 0;

    //display image
    image(images[frame][direction], position.x, position.y);
  }

  void move()
  {
    switch (enemyState) {
    case MOVING:
      //moves
      position.add(velocity);
      checkDirection();
      break;
    case EATING:
      //eating - no movement
      break;
    }
  }

  void checkDirection() {
    //0=N, 1=NE, 2=E, 3=SE, 4=S, 5=SW, 6=W, 7=NW
    if (velocity.x > 0) {
      if (velocity.y > 0.5) {
        direction = 3;
      } else if (velocity.y < -0.5) {
        direction = 1;
      } else direction = 2;
    } else if (velocity.x < 0) {
      if (velocity.y > 0.5) {
        direction = 5;
      } else if (velocity.y < -0.5) {
        direction = 7;
      } else direction = 6;
    } else {
      if (velocity.y < -0.5 ) direction = 0;
      else if (velocity.y > 0.5) direction = 4;
    }
  }

  boolean isEating() {
    if (this.enemyState == EnemyState.EATING) return true;
    else return false;
  }

  abstract void update();

  //collision with cake
  void targetHit(Goal other)
  {
    if (this.position.x < other.x+40 && this.position.x > other.x-60 && this.position.y < other.y+40 && this.position.y > other.y-60)
    {
      enemyState = EnemyState.EATING;
    }
  }

  //collision with eachother
  boolean collides(Enemy other) // collision with eachother (same obj)
  {
    if (this!=other)
    {
      return dist(this.position.x, this.position.y, other.position.x, other.position.y)<50; // collisions with objects of the same class
    } else
    {
      return false; // no collision detected
    }
  }


  PVector getRandomBorder() // PICKS RANDOM LOCATION FROM SCREENS BORDER
  {
    int side = (int)random(0, 4); // 0 = left 1 = up 2 = right 3 = down
    //get random boarder procedure
    // if (side) return x and y

    if (side==0) // left
    {
      return new PVector(0, random(1, 500)); //random Y
    }
    if (side==1) // upper
    {
      return new PVector(random(1, 500), 0); //random X
    }
    if (side==2) // right
    {
      return new PVector(500, random(1, 500)); // random Y
    }
    if (side==3) // bottom
    {
      return new PVector(random(1, 500), 500); // random X
    } else {
      print("issue with getRandomBoarder"); // shows if error occurs
      return new PVector(0, 0);
    }
  }

  //velocity for movement
  PVector getVelocity(PVector target)
  {
    position = getRandomBorder(); // start position

    while (PVector.dist(position, target)<50) // prevent two points being too close
    {
      target = getRandomBorder();
    }

    velocity = PVector.sub(target, position); // finds direction towards target location
    velocity.normalize();
    velocity.mult(speed); // sets speed of obj
    return velocity;
  }
}

enum EnemyState {
  MOVING, EATING
}
