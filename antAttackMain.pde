//game //<>//
gameState mode = gameState.MAINMENU;

int framecount = 0;
int spawnframe1, spawnframe2, spawnframe3;

//objects
Player player1;
Goal cake;

//polymorphic array
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
//arraylists
ArrayList<Ants> ants = new ArrayList<Ants>();
ArrayList<Bee> bees = new ArrayList<Bee>();
ArrayList<FireAnt> fireAnts = new ArrayList<FireAnt>();

ArrayList<Explosion> explosions = new ArrayList<Explosion>();

//number of enemies to be on screen at one time
int maxAnt = 7;
int maxBee = 1;
int maxFireAnt = 2;

//enemies on the goal at one time
float numOnGoal = 0;

//name input
boolean nameEntered = false;
boolean typing = false;
String typed = "";
String playerName;

//images
PImage backdrop;
PImage GameOver;
PImage mainMenu;
PImage howToPlay;

//leaderboard
String[] entries;
String[] name;
int[] score;
boolean addedScore = false;


void setup()
{
  size(500, 500);

  //objects constructor method
  cake = new Goal(250, 250);
  player1 = new Player(width/2, 400);

  //load backgrounds
  backdrop = loadImage("grass.png");
  GameOver = loadImage("GameOver.png");
  mainMenu = loadImage("mainMenu.png");
  howToPlay = loadImage("HowToPlay.png");
}

void draw()
{
  //switch between menus
  switch (mode) {
  case MAINMENU:
    mainMenuScreen();
    break;
  case GAMEOVER:
    GameOverScreen();
    break;
  case GAME:
    mainGame();
    break;
  case HOWTOPLAY:
    howToPlayScreen();
    break;
  case LEADERBOARD:
    displayLeaderboard();
    break;
  }
}

void mainMenuScreen() {
  //leaderboard entries to reload each time main menu is started
  scoresLoad();
  nameEntered = false;
  addedScore = false;

  background(mainMenu);

  //button functions
  Buttons start = new Buttons(250, 250, 100, color(255, 50, 50), "START GAME");
  Buttons HTP = new Buttons(250, 315, 100, color(50, 255, 50), "HOW TO PLAY");
  Buttons leaderboard = new Buttons(250, 380, 100, color(50, 50, 255), "LEADERBOARD");

  start.display();
  HTP.display();
  leaderboard.display();

  if (start.clicked() == true) {
    mode = gameState.GAME;
    restart();
  }
  if (HTP.clicked() == true) {
    mode = gameState.HOWTOPLAY;
  }
  if (leaderboard.clicked() == true) {
    mode = gameState.LEADERBOARD;
  }
}

void howToPlayScreen() {
  background(howToPlay);
  Buttons back = new Buttons(400, 290, 70, color(50, 255, 50), "RETURN TO\n MAIN MENU");

  back.display();

  if (back.clicked()==true) {
    mode = gameState.MAINMENU;
  }
}

void mainGame() {
  background(backdrop);
  noCursor();

  //updates goal, player, enemies
  cake.update();
  enemyEating();

  spawn();

  //update all enemies on screen
  for (int i = 0; i<enemies.size(); i++)
  {
    enemies.get(i).update();
  }

  enemyCollisions();

  player1.update();
  mouseClick();

  cake.goalReached(numOnGoal);

  framecount += 1;

  displayExplosion();

  if (cake.gameEnd() == true) mode = gameState.GAMEOVER;
}

void spawn()
{
  //ants
  if (ants.size() < maxAnt) {
    spawnframe1 = (int)random(20, 500);
    if (framecount >= spawnframe1) {
      Ants ant = new Ants();
      ants.add(ant);
      enemies.add(ant);
    }
  }

  //fire ants
  if (fireAnts.size() < maxFireAnt) {
    spawnframe2 = (int)random(20, 200);
    if (framecount >= spawnframe2) {
      FireAnt fireAnt = new FireAnt();
      fireAnts.add(fireAnt);
      enemies.add(fireAnt);
    }
  }

  //bees
  if (bees.size()<maxBee)
  {
    spawnframe3 = (int)random(20, 300);
    if (framecount >= spawnframe3) {
      Bee bee = new Bee();
      bees.add(bee);
      enemies.add(bee);
    }
  }

  //reset
  if (framecount >= spawnframe3 && framecount >= spawnframe2 && framecount >= spawnframe1) {
    framecount = 0;
  }
}

void enemyCollisions()
{
  //collision with eachother
  for (Enemy i : enemies)
  {
    for (Enemy a : enemies)
    {
      if (a.enemyState != EnemyState.EATING && i.enemyState != EnemyState.EATING) {
        if (a.collides(i))
        {
          PVector bounce = PVector.sub(a.position, i.position); //bounce off eachother slightly
          bounce.normalize();
          bounce.mult(10);
          a.position.add(bounce);
          i.position.sub(bounce);
        }
      }
    }
    //collision with goal
    i.targetHit(cake);
  }
}

void mouseClick() {
  //player click on enemies
  for (int i = 0; i<enemies.size(); i++) {
    Enemy e = enemies.get(i);
    if (player1.overEnemy(e)==true && mousePressed==true) {
      //if enemy is on cake, number on cake updated
      if (e.isEating())
      {
        numOnGoal -= 1;
      }
      enemyRemoval(e);
      //score increase
      player1.score += e.points;
    }
  }
  //player click on cake
  if (player1.overGoal(cake)==true && mousePressed == true) {
    for (int i = 0; i<enemies.size(); i++) {
      if (enemies.get(i).isEating() == true)
      {
        //kills all which are eating
        player1.score += 1;
        numOnGoal -= 1;
        enemyRemoval(enemies.get(i));
      }
    }
  }
}

void enemyEating()
{
  //track number of enemies on cake
  for (Enemy e : enemies)
  {
    if (e.isEating() && e.checkedEating == false)
    {
      numOnGoal += 1;
      e.checkedEating = true; // true when enemy is checked whether its eating, saves any being counted twice
    }
  }
}

void enemyRemoval(Enemy e)
{
  //removes enemy when killed and sets up for explosion
  if (e instanceof Bee) {
    mainExplosion(e.position.x, e.position.y, color(0, 255, 0));
    bees.remove(e);
  } else if (e instanceof Ants) {
    mainExplosion(e.position.x, e.position.y, color(0, 255, 0));
    ants.remove(e);
  } else if (e instanceof FireAnt) {
    fireAntExplosion(e.position.x, e.position.y);
    fireAnts.remove(e);
  }
  //remove from polymorphic array list
  enemies.remove(e);
}

void mainExplosion(float x, float y, color c) {
  //creates exposion for enemies to aim for
  Explosion ex = new Explosion(x, y, c);
  explosions.add(ex);
}

void fireAntExplosion(float x, float y) {
  //creates explosion for enemies to avoid
  Explosion ex = new Explosion(x, y);
  explosions.add(ex);
}

void displayExplosion() {
  for (Explosion e : explosions) {
    e.display();
    noTint();
    //remove when completed
    if (e.done == true) explosions.remove(e);
  }
}

void GameOverScreen() {
  cursor();
  //load leaderboard scores to arrays
  scoresLoad();
  background(GameOver);
  Buttons MMB = new Buttons(355, 340, 100, color(255, 50, 50), "MAIN MENU");

  // players final score
  textSize(20);
  text("FINAL SCORE: " + player1.score, 20, 350);

  //takes user name for leaderboard
  text("TYPE YOUR NAME AND PRESS ENTER FOR LEADERBOARD: ", 10, 430);
  inputName();

  MMB.display();
  if (MMB.clicked() == true) {
    mode = gameState.MAINMENU;
  }

  //save scores with name
  if (nameEntered == true) addScores(playerName, player1.score);

  if (addedScore == true) {
    fill(255, 255, 255);
    text("SCORE ADDED", 350, 460);
  }
}

void scoresLoad() {
  //stores names and scores in arrays
  entries = loadStrings("leaderboard.txt");

  if (entries == null) {
    entries = new String[0];
  }

  name = new String[entries.length];
  score = new int[entries.length];

  for (int i = 0; i<entries.length; i++) {
    //split lines into score and names
    name[i] = entries[i].substring(0, entries[i].indexOf(","));
    score[i] = int(entries[i].substring(entries[i].indexOf(",") + 1, entries[i].length()));
  }
}

void inputName() {
  //creates a text box for input
  rectMode(CENTER);
  fill(255, 255, 255);
  rect(80, 460, 100, 40);
  fill(0, 0, 0);
  //displays
  text(typed, 30, 460);
  //toggle typing active/inactive
  if (mouseX > 20 && mouseX < 130 && mouseY > 440 && mouseY < 480 && mousePressed == true) {
    typing = true;
  }
  if (mousePressed && !(mouseX > 30 && mouseX < 130 && mouseY > 440 && mouseY < 480)) {
    typing = false;
  }
}

void addScores(String n, int s) {
  //updating file
  if (addedScore == false) {
    entries = append(entries, n + "," + s);
    name = append(name, n);
    score = append(score, s);

    //sort before saving
    BubbleSortScores();

    saveStrings("leaderboard.txt", entries);
    addedScore = true;
  }
}

void BubbleSortScores() {
  boolean swapped = true;
  while (swapped==true) {
    swapped = false;
    //bubble sort scores to be in correct order on leaderboard
    for (int i = 0; i<entries.length - 1; i++) {
      if (score[i]<score[i+1]) {
        //swap score and name
        int tempScore = score[i];
        score[i] = score[i+1];
        score[i+1] = tempScore;

        String tempName = name[i];
        name[i] = name[i+1];
        name[i+1] = tempName;
        swapped = true;
      }
    }
  }
  //rebuilding entries with name and scores
  for (int i = 0; i<entries.length; i++) {
    entries[i] = (name[i] + "," + score[i]);
  }
}


void displayLeaderboard() {
  background(200, 0, 0);

  //setup
  textSize(50);
  text("LEADERBOARD!!", 60, 50);
  textSize(20);
  text("No.", 70, 70);
  text("Name", 130, 70);
  text("Score", 310, 70);
  line(60, 80, 400, 80);

  //each row from file
  for (int i = 0; i < entries.length; i++) {
    String names = entries[i].substring(0, entries[i].indexOf(","));
    String scores = entries[i].substring(entries[i].indexOf(",")+1, entries[i].length());

    //on screen leaderboard
    text(i+1, 60, 110 + i * 30);
    text(names, 130, 110 + i * 30);
    text(scores, 310, 110 + i * 30);
  }

  //returning to menu
  Buttons back = new Buttons(400, 450, 55, color(255), "Back to Menu");
  back.display();

  if (back.clicked()== true) {
    mode = gameState.MAINMENU;
  }
}

void restart() {
  //resetting variables when game is restarting.
  player1.score = 0;
  cake.life = 1000;
}

void keyPressed() {
  //takes users name input
  if (typing == false) return;

  //backspace
  if (typed.length() > 0 && key == BACKSPACE) typed = typed.substring(0, typed.length()-1);

  //input taken
  else if (key == RETURN || key == ENTER) {
    playerName = typed;
    typing = false;
    nameEntered = true;
  } else if (key != CODED) typed+=key;
}

enum gameState { //different menus
  MAINMENU, GAME, GAMEOVER, HOWTOPLAY, LEADERBOARD
}
