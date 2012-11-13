PApplet applet;
Globals globals;
Fonts fonts;
Mouse mouse;
Keyboard keyboard;
Sounds sounds;
Player player;
Sky sky;
World world;
Score score;

ArrayList enemies;
ArrayList objects;

Bullet[] bullets;

Button playAgainButton;
Button volumeButton;

PImage volumeIcon;


/*
ENEMY TYPE LEGEND
1 = gilliam knight
2 = kintot
*/

// tileX, tileY, type
private final int[][] enemyData = {
  {3, 5, 1},
  {5, 10, 2},
  {6, 10, 2},
  {8, 8, 1},
  {14, 3, 1},
  {21, 10, 2},
  {22, 10, 2},
  {24, 10, 2},
  {25, 10, 2},
  {27, 10, 2},
  {28, 10, 2},
  {30, 10, 2},
  {31, 10, 2},
  {38, 2, 1},
  {41, 6, 1},
  {43, 10, 2},
  {44, 10, 2},
  {45, 10, 2},
  {46, 10, 2}
};

private final int[][] volumeButtonColorsOn = {
  {50, 200, 50},
  {70, 220, 70}
};

private final int[][] volumeButtonColorsOff = {
  {200, 50, 50},
  {220, 70, 70}
};

private final int[][] playAgainButtonColors = {
  {255, 255, 255},
  {200, 200, 200}
};

/* 
-----------------------------
ALIGNMENT CHART
1 = top left
2 = top middle
3 = top right
4 = middle right
5 = bottom right
6 = bottom middle
7 = bottom left
8 = middle left
-----------------------------  
OBJECT TYPES
1 = spring weak
2 = spring strong
3 = tree
4 = sign
5 = coin
-----------------------------
legend: tileX, tileY, alignment, objectType
*/
private final int[][] interactiveObjectData = {
  {1, 8, 6, 2},
  {2, 8, 7, 5},
  {2, 8, 6, 5},
  {4, 5, 6, 4},
  {9, 8, 6, 3},
  {11, 8, 6, 2},
  {14, 3, 6, 3},
  {15, 3, 7, 5},
  {15, 3, 6, 5},
  {15, 3, 5, 5},
  {17, 7, 6, 2},
  {19, 7, 6, 3},
  {20, 7, 6, 1},
  {23, 5, 6, 5},
  {26, 4, 6, 5},
  {29, 6, 6, 1},
  {34, 4, 6, 3},
  {36, 4, 6, 1},
  {37, 2, 6, 5},
  {37, 2, 5, 5},
  {38, 2, 6, 4},
  {39, 2, 7, 5},
  {39, 2, 6, 5},
  {41, 6, 6, 3}
};

private PImage tileSheetInterativeObjects;

  
/*** GAME NOTES:

  + fix tile padding bug when set to 0
  + don't draw tiles that are outside the viewport
  + build animation class
  
***/

void setup () {

  applet = this;
  globals = new Globals();

  applet.size(globals.viewportWidth, globals.viewportHeight);
  applet.noSmooth();
  applet.noStroke();

  volumeIcon = loadImage("resources/volume.png");
  tileSheetInterativeObjects = loadImage("resources/objects-tileset.gif");

  sounds = new Sounds(applet);
  
  enemies = new ArrayList();
  objects = new ArrayList();

  bullets = new Bullet[globals.maxBullets];
  
  fonts = new Fonts();
  mouse = new Mouse();
  keyboard = new Keyboard();
  sky = new Sky();
  world = new World(60, 60);
  player = new Player(0, 5);
  //player = new Player(33, 4);
  score = new Score();
  
  world.init();
  player.init();
  
  for (int i = 0, ii = enemyData.length; i < ii; i++) {
    if (enemyData[i][2] == 1) enemies.add(new GilliamKnight(enemyData[i][0], enemyData[i][1]));
    else if (enemyData[i][2] == 2) enemies.add(new Kintot(enemyData[i][0], enemyData[i][1]));
  }
  
  for (int i = 0; i < interactiveObjectData.length; i++) {
    int[] obj = interactiveObjectData[i];
    switch (obj[3]) {
      case 1: // weak spring
        objects.add(new WeakSpring(obj[0], obj[1], obj[2]));
        break;
      case 2: // strong spring
        objects.add(new StrongSpring(obj[0], obj[1], obj[2]));
        break;
      case 3: // tree
        objects.add(new Tree(obj[0], obj[1], obj[2]));
        break;
      case 4: // sign
        objects.add(new CommonObject(obj[0], obj[1], 64, 12, 32, 48, obj[2]));
        break;
      case 5: // coin
        objects.add(new Coin(obj[0], obj[1], obj[2]));
        break;
    } 
  }
  
  // create all the bullets at once and toggle them on/off as needed
  for (int i = 0, ii = globals.maxBullets; i < ii; i++) bullets[i] = new Bullet();

  playAgainButton = new Button(globals.viewportHalfWidth - 100, 400, 200, 50, playAgainButtonColors);
  playAgainButton.addText("PLAY SOME MORE");

  volumeButton = new Button(globals.viewportWidth - 50, 10, 38, 38, volumeButtonColorsOn);
  volumeButton.addIcon(volumeIcon.get(0, 0, 38, 38), 0, 0, 38, 38);
  
  if (globals.noSound) {
    sounds.mute();
    volumeButton.changeIcon(volumeIcon.get(0, 38, 38, 38), 0, 0, 38, 38);
    volumeButton.changeColor(volumeButtonColorsOff);
  }
  
  sounds.loopAudio(sounds.music);
 
}

void stop() {
  sounds.unload();
}

void draw () {
 
  if (player.isAlive) {
    
    applet.background(120);
    
    sky.redraw();
    world.redraw();    
    player.redraw();

    for (int i = 0, ii = enemies.size(); i < ii; i++) {
      Enemy enemy = (Enemy) enemies.get(i);
      if (enemy.isAlive || enemy.isExploding) enemy.redraw();
      if (enemy.isAlive && player.isTouching(enemy.posX, enemy.posY, enemy.sizeWidth, enemy.sizeHeight)) player.destroy();
    }
        
    for (int i = 0, ii = objects.size(); i < ii; i++) {
      InteractiveObject intObj = (InteractiveObject) objects.get(i);
      if (intObj.isAvailable && world.isDrawable(intObj.tileX, 2)) {
        intObj.redraw();
        image(intObj.spriteBlock, intObj.posX, intObj.posY, intObj.sizeWidth, intObj.sizeHeight);
      }
    }
    
    for (int i = 0, ii = globals.maxBullets; i < ii; i++) if (bullets[i].isActive) {
      Bullet bullet = bullets[i];
      bullet.redraw();
      for (int n = 0, nn = enemies.size(); n < nn; n++) {
        Enemy enemy = (Enemy) enemies.get(n);
        if (enemy.isAlive && bullet.isTouching(enemy.posX, enemy.posY, enemy.sizeWidth, enemy.sizeHeight)) {
          enemy.destroy();
          bullet.destroy();
        }
      }
    }
    
    applet.translate(abs(world.posX), abs(world.posY));

    score.redraw();
    volumeButton.redraw();
        
    if (volumeButton.isActive) {
      if (sounds.isMuted) {
        sounds.unmute();
        volumeButton.changeIcon(volumeIcon.get(0, 0, 38, 38), 0, 0, 38, 38);
        volumeButton.changeColor(volumeButtonColorsOn);
      } else {
        sounds.mute();
        volumeButton.changeIcon(volumeIcon.get(0, 38, 38, 38), 0, 0, 38, 38);
        volumeButton.changeColor(volumeButtonColorsOff);
      }
    }

    //translate(world.posX, world.posY);
    
  } else {
    
    sounds.pauseAudio(sounds.music);
    
    applet.background(255, 0, 0);
    
    applet.fill(255);
    applet.textFont(fonts.AndaleMono);
    applet.textAlign(CENTER);
    applet.text("YOU DEAD", globals.viewportHalfWidth, globals.viewportHalfHeight);
    applet.textFont(fonts.TheSans);
    applet.text("You have " + score.p + " points", globals.viewportHalfWidth, globals.viewportHalfHeight + 30);

    if (playAgainButton.isActive) {
      
      playAgainButton.reset();
      player.reset();
      world.reset();
      score.reset();      
      
      for (int i = 0, ii = enemies.size(); i < ii; i++) {
        Enemy enemy = (Enemy) enemies.get(i);
        enemy.reset();
      }
      
      for (int i = 0, ii = objects.size(); i < ii; i++) {
        InteractiveObject intObj = (InteractiveObject) objects.get(i);
        intObj.reset();
      }
      
      for (int i = 0, ii = globals.maxBullets; i < ii; i++) bullets[i].destroy();
      
      sounds.loopAudio(sounds.music);
      
    } else playAgainButton.redraw();
    
  }
  
  if (mouse.wasClicked) mouse.reset();

}


void keyPressed () {
  keyboard.pressed(keyCode);
}

void keyReleased () {
  keyboard.released(keyCode);
}

void mousePressed () {
  mouse.pressed();
}

void mouseReleased () {
  mouse.released();
}






