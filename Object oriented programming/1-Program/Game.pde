/**
 @author: Ernestas Škudzinskas
 
 A simple game set in prehistoric times.
 Also has a map edditor.
 
 **/

import java.awt.*;
TextField textField = new TextField("", 300);

final static float moveSpeed = 5;
final static float jumpSpeed = 16;
final static float spriteSize = 32;
final static float gravity = 0.6;

final static float rightMargin = 400;
final static float leftMargin = 100;
final static float verticalMargin = 100;



Player player;
PImage playerRight, playerLeft;
PImage masterSprite;
PImage[] tiles;
ArrayList<Sprite> platforms;
ArrayList<Sprite> hostiles;
TextBox text = new TextBox();
Sprite exit;
Sprite start, edit;
Sprite mousePoint;


float viewX = 0;
float viewY = 0;

// -1  edditor, 0 game screen, 1-3 levels
int level = 0;

///Edditor
ArrayList<Sprite> replacableTiles;
ArrayList<Sprite> selectionTiles;
int index = 1, selected = 0;
Sprite save, mapExit;
Sprite next, prev;


void setup()
{
  
  size(700, 500);
  imageMode(CENTER);

  //Initialize the player
  player = new Player(60, 60);
  text.W = 350;
  text.H = 240;

  //Create player animation arrays
  player.idle = new PImage[2][8];
  player.run = new PImage[2][8];
  player.jump = new PImage[2][8];

  //Load player animations ands set a default
  playerRight = loadImage("images/cavermanRight.png");
  playerLeft = loadImage("images/cavermanLeft.png");
  loadPlayerSprites(0, playerLeft);
  loadPlayerSprites(1, playerRight);
  player.img = player.idle[1][0];
  player.currentAnimation = player.idle[1];

  //Load tileset, and create tiles.
  masterSprite = loadImage("images/tileset.png");
  platforms = new ArrayList<Sprite>();
  hostiles = new ArrayList<Sprite>();
  exit = new Sprite();
  tiles = new PImage[ (masterSprite.height) * (masterSprite.width) ];
  makeTiles(masterSprite);


  //Load play and eddit buton
  PImage startImg = loadImage("images/Start.png");
  start = new Sprite(startImg, 350, 270);
  PImage editImg = loadImage("images/Edit.png");
  edit = new Sprite(editImg, 350, 350);


  //Edditor
  PImage nextImg = loadImage("images/next.png");
  PImage prevImg = loadImage("images/prev.png");
  PImage saveImg = loadImage("images/save.png");
  PImage exitImg = loadImage("images/mapExit.png");
  next = new Sprite(nextImg);
  prev = new Sprite(prevImg);
  save = new Sprite(saveImg);
  mapExit = new Sprite(exitImg);
}

void draw()
{
  
  if (level == 0)
  {
    background(#fa6b55);
    start.display();
    edit.display();
    
    if (mousePoint != null)
    {
      if (checkCollision(mousePoint, start))
      {
        level = 1;

        loadLevel(level);
         
      }
      if (checkCollision(mousePoint, edit))
      {
        level = -1;
        initializeEdditor();
        updateSelection(1);
      }
    }
  } else if (level == -1)
  {
    /**
     create a grid of Sprite objects
     on clikc check collisions if 
     
     */
    edditor();
  } else
  {
    background(102, 204, 255);
    scroll();

    displayAll();

    boolean reachedEnd = checkCollision(player, exit);
    if (reachedEnd)
    {
      level++;
      if (level < 4)
        loadLevel(level);
      else
      {
        resetPlatforms();
        level = 0;
      }
    }
  
    
    ArrayList<Sprite> hostileCollisions = checkCollisionList(player, hostiles);
    if (hostileCollisions.size() > 0)
    {
      resetPlatforms();
      level = 0;
    }
  }

  //text.X = (int)viewX - 0;
  //text.Y = (int)viewY - 0;
  
  //text.DRAW(); 

  
}

///////////////////Movement
void keyPressed()
{
  if (keyCode == RIGHT)
  {
    player.changeX = moveSpeed;
  } else if (keyCode == LEFT)
  {
    player.changeX = -moveSpeed;
  } else if (keyCode == UP && isOnPlatforms(player, platforms))
  {
    player.changeY = -jumpSpeed;
  } else if (keyCode == DOWN)
  {
    player.changeY = jumpSpeed;
  }
  
  if(text.KEYPRESSED(key, (int)keyCode)) 
  {
     Submit();
  }
}


void Submit() 
{
  print("Pressed enter");  
  if(text.Text.equals("right")) 
  {
      
  }
}

void keyReleased()
{
  if (keyCode == RIGHT)
  {
    player.changeX = 0;
  } else if (keyCode == LEFT)
  {
    player.changeX = 0;
  } else if (keyCode == UP)
  {
    //player.changeY = 0;
  } else if (keyCode == DOWN)
  {
    player.changeY = 0;
  }
}

///////Mouse
void mousePressed()
{
  text.PRESSED(mouseX, mouseY);
  mousePoint = new Sprite(mouseX, mouseY, 1, 1);
  
}

void mouseReleased()
{
  mousePoint = null;
  
}

/////////Scrolling
void scroll()
{
  float rightBoundary = viewX + width  -rightMargin;
  if (player.getRight() > rightBoundary)
  {
    viewX += player.getRight() - rightBoundary;
  }

  float leftBoundary = viewX + leftMargin;
  if (player.getLeft() < leftBoundary)
  {
    viewX -= leftBoundary - player.getLeft();
  }

  float bottomBoundary = viewY + height - verticalMargin;
  if (player.getBottom() > bottomBoundary)
  {
    viewY += player.getBottom() - bottomBoundary;
  }

  float topBoundary = viewY + verticalMargin;
  if (player.getTop() < topBoundary)
  {
    viewY -= topBoundary - player.getTop();
  }

  translate(-viewX, -viewY);
}


/////Display all entities
void displayAll()
{   
  player.updateAnimation();
  player.display();  

  resolvePlatformCollisions(player, platforms);

  for (Sprite s : platforms)
    s.display(); 

  for (Sprite s : hostiles)
    s.display();

  if (exit.img != null)
    exit.display();
  
  
  text.X = (int)viewX - 0;
  text.Y = (int)viewY - 0;
  
  text.DRAW(); 
  
}


void createPlatforms(String filename)
{
  /**
   Adds all tiles from the csv file
   
   */
  String[] lines = loadStrings(filename);

  for (int row = 0; row < lines.length; row++)
  {
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++)
    {
      int temp =  Integer.parseInt(values[col]);
      if (temp != -1 && temp != 500)
      {
        //System.out.print(temp);
        //System.out.print(" ");
        Sprite s = new Sprite(tiles[temp]);
        s.centerX = spriteSize/2 + col * spriteSize;
        s.centerY = spriteSize/2 + row * spriteSize;
        s.imageNumber = temp;

        //*Add enemies 163 + 164
        //*Add finsh 153 | 154 exit point
        if (temp == 153)
        {
          exit = s;
        } else if (temp == 163 || temp == 164)
        {
          hostiles.add(s);
        } else
        {
          platforms.add(s);
        }
      } else if (temp == 500)
      {
        player.centerX = spriteSize/2 + col * spriteSize;
        player.centerY = spriteSize/2 + row * spriteSize;
      }
    }
  }
}

void loadPlayerSprites(int dir, PImage img)
{
  for (int i = 0; i < 7; i++)
  {
    player.idle[dir][i] = img.get((97 * i), (70 * 0), 65, 58);
  }

  for (int i = 0; i < 7; i++)
  {
    player.run[dir][i] = img.get((97 * i), (70 * 1), 65, 58);
  }

  for (int i = 0; i < 7; i++)
  {
    player.jump[dir][i] = img.get((97 * i), (70 * 2), 65, 58);
  }
}

void makeTiles(PImage img)
{
  /*
      Makes all the tiles from spritesheet
   
   */
  int counter = 0;
  for (int i = 0; i < (img.height) / 32; i++)
  {
    for (int j = 0; j < (img.width) / 32; j++)
    {
      tiles[counter] = new PImage();
      tiles[counter] = img.get( (32 * j), (32 * i), 32, 32);

      counter++;
    }
  }
}

////Colission detection
boolean checkCollision(Sprite s1, Sprite s2)
{
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight(); 
  boolean noYoverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();

  if ( noXOverlap || noYoverlap)
  {
    return false;
  } else {
    return true;
  }
}

///Check all collisions 
ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list)
{
  ArrayList<Sprite> collisionList = new ArrayList<Sprite>();
  for (Sprite checkingS : list)
  {
    if (checkCollision(s, checkingS))
      collisionList.add(checkingS);
  }

  return collisionList;
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> platforms)
{
  s.centerY += 5;
  ArrayList<Sprite> collisionList = checkCollisionList(s, platforms);
  s.centerY -= 5;
  if (collisionList.size() > 0)
  {
    return true;
  } else
    return false;
}


void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> platforms)
{
  s.changeY += gravity;
  s.centerY += s.changeY;

  //Move in y, and check if it collides
  ArrayList<Sprite> colisionList = checkCollisionList(s, platforms);
  if (colisionList.size() > 0)
  {
    Sprite collided = colisionList.get(0); 
    if (s.changeY > 0)
    {
      s.setBottom(collided.getTop());
    } else {
      s.setTop(collided.getBottom());
    }
    s.changeY = 0;
  }

  s.centerX += s.changeX;
  colisionList = checkCollisionList(s, platforms);
  if (colisionList.size() > 0)
  {
    Sprite collided = colisionList.get(0); 
    if (s.changeX > 0)
    {
      s.setRight(collided.getLeft());
    } else {
      s.setLeft(collided.getRight());
    }
    s.changeX = 0;
  }
}

////check for deat
//void reset()
//{

//}

void loadLevel(int level)
{
  resetPlatforms();
  createPlatforms("levels/Level" + (level) + ".csv");
  //player.centerX = 100;
  //player.centerY = 100;
}

void resetPlatforms()
{
  platforms = new ArrayList<Sprite>();
  hostiles = new ArrayList<Sprite>();
  exit = new Sprite();
}
///Edditor

void initializeEdditor()
{
  replacableTiles = new ArrayList<Sprite>();
  for (int i = 0; i < 15; i++)
  {
    for (int j = 0; j < 14; j++)
    {
      Sprite s = new Sprite("images/replacable.png", 1, (32 * i), (32 * j) );
      s.centerX = spriteSize/2 + i * spriteSize;
      s.centerY = spriteSize/2 + j * spriteSize;
      s.imageNumber = -1;
      replacableTiles.add(s);
    }
  }
  //save, mapExit, prev, next
  save.centerX = 90; 
  save.centerY = 470; 
  save.w = save.img.width; 
  save.h = save.img.height;
  mapExit.centerX = 230; 
  mapExit.centerY = 470; 
  mapExit.w = save.img.width; 
  mapExit.h = save.img.height;
  prev.centerX = 500; 
  prev.centerY = 470; 
  prev.w = prev.img.width; 
  prev.h = prev.img.height;
  next.centerX = 650; 
  next.centerY = 470; 
  next.w = prev.img.width; 
  next.h = next.img.height;
}

void updateSelection(int index)
{  
  selectionTiles = new ArrayList<Sprite>();
  int counter = (index - 1) * (14 * 6);
  for (int i = 0; i < 14; i++)
  {
    for (int j = 0; j < 6; j++)
    {
      Sprite s = new Sprite(tiles[counter]);
      s.centerX = spriteSize/2 + (j + 15) * spriteSize;
      s.centerY = spriteSize/2 + i * spriteSize;
      s.imageNumber = counter;
      //System.out.print(s.imageNumber);
      //System.out.print(" ");
      selectionTiles.add(s);
      counter++;
    }
  }
}

void displayButtons()
{
  //save, mapExit, prev, next
  save.display();
  mapExit.display();
  prev.display();
  next.display();
}

void saveMap()
{
  Table map = new Table();
  for (int j = 0; j < 15; j++)
    map.addColumn();
  for (int i = 0; i < 14; i++)
    map.addRow();


  int counter = 0;
  for (int i = 0; i < 15; i++)
  {
    for (int j = 0; j < 14; j++)
    {
      Sprite temp = replacableTiles.get(counter);
      map.setInt(j, i, temp.imageNumber);
      counter++;
    }
  }
  saveTable(map, "newMap.csv");
}

void edditor()
{
  background(#687d6d);
  updateSelection(index);
  for (Sprite s : replacableTiles)
    s.display();

  for (Sprite s : selectionTiles)
    s.display();

  displayButtons();

  //Check for mouse clicks
  if (mousePoint != null)
  {
    boolean saveButton = checkCollision(mousePoint, save);
    boolean mapExitButton = checkCollision(mousePoint, mapExit); 
    boolean nextButton = checkCollision(mousePoint, next); 
    boolean prevButton = checkCollision(mousePoint, prev);

    if (saveButton)
    {
      saveMap();
    }
    if (mapExitButton)
    {
      level = 0;
    }
    if (nextButton)
    {
      if (index <= 5)
        index++; 
      delay(200);
    }
    if (prevButton)
    {  
      if (index > 1)
        index--;
      delay(200);
    }

    //check if pressed on replacable, or selection.
    ArrayList<Sprite> changePlacable = checkCollisionList(mousePoint, replacableTiles);
    ArrayList<Sprite> changeSelection = checkCollisionList(mousePoint, selectionTiles);

    if (changePlacable.size() > 0)
    {
      if (selected != -1)
      {
        Sprite temp = changePlacable.get(0);
        temp.img = tiles[selected];
        temp.imageNumber = selected;
      }
    }

    if (changeSelection.size() > 0)
    {
      Sprite temp = changeSelection.get(0);
      selected = temp.imageNumber;
    }
  }
}
