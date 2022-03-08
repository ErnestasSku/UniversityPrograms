 //<>//
//import String;
import java.beans.Expression;
import javax.script.ScriptEngineManager;
import javax.script.ScriptEngine;
import javax.script.ScriptException;
import g4p_controls.*;

//Input text
GTextArea text;
String startText;

//Scrolling variables
final static float rightMargin = 400;
final static float leftMargin = 400;
final static float verticalMargin = 100;


//Game sprites
Player player;
PImage playerLeft, playerRight;
float moveSpeed = 1;
PImage masterSprite;
PImage bushesSprite;
PImage[] tiles;
ArrayList<Sprite> path;
ArrayList<Sprite> obstacles;
ArrayList<Sprite> coins;
Sprite startCommands;
PImage CoinSprite;

int time = 0;

Sprite mousePoint;

float viewX = 0;
float viewY = 0;

int level = 2;

void setup()
{
  size(900, 700);
  imageMode(CENTER);

  // Add text box
  startText = "Įveskite kodą";
  text = new GTextArea(this, 600, 60, 250, 250, G4P.SCROLLBARS_BOTH | G4P.SCROLLBARS_AUTOHIDE);
  text.setText(startText, 310);
  text.setPromptText("Įveskite kodą");
  startCommands = new Sprite(loadImage("Start.png"));
  startCommands.centerX = 650;
  startCommands.centerY = 320;
  startCommands.w = 100;
  // ****************


  // Initialize the player
  player = new Player(5, 5);
  player.centerX = 24;
  player.centerY = 2;

  player.idle = new PImage[4][4];
  player.walk = new PImage[4][4];

  playerRight = loadImage("character.png");
  playerLeft = loadImage("characterLeft.png");
  loadPlayerSprites(playerRight, playerLeft);
  player.img = player.idle[0][0];
  player.currentAnimation = player.walk[0];
  // ***************************

  //Load tileset and create tiles
  masterSprite = loadImage("Tiles.png");
  bushesSprite = loadImage("Bushes.png");
  CoinSprite = loadImage("coin.png");
  path = new ArrayList<Sprite>();
  obstacles = new ArrayList<Sprite>();
  coins =  new ArrayList<Sprite>();
  tiles = new PImage[200];
  makeTiles(masterSprite, bushesSprite);


  loadLevel(level);
  // **************************
}

int it = 0;
int currentMove = 0;
boolean excecute = false;
void draw() 
{
  background(51, 255, 153);
  player.img = player.currentAnimation[it];

  //scroll();
  displayAll();

  if (time != -1)
    time--;
  if (time == 0)
  {
    time = -1;
    player.changeX = 0;
    player.changeY = 0;
  }

  if (excecute && time == -1)
  {
    String s = finalCommands.get(currentMove);
    currentMove++;
    if (currentMove >= finalCommands.size())
    {
      currentMove = 0;
      excecute = false;
    }
    if (s.equals("right")) {
      time = 0;
      player.angle += 90;
    } else if (s.equals("left")) {
      time = 0;
      player.angle += 270;
    } else if (s.equals("up")) {
      time = 0;
      player.angle = 180;
    } else if (s.equals("down")) {
      time = 0;
      player.angle = 0;
    } else if (s.equals("lookToRight")) {
      time = 0;
      player.angle = 270;
    } else if (s.equals("lookToLeft")) {
      time = 0;
      player.angle = 90;
    } else if (s.equals("go")) {
      time = 17;

      int direction = player.selectDirection();

      if ( direction == 0)
        player.changeY = 1;
      else if (direction == 1)
        player.changeX = -1;
      else if (direction == 2)
        player.changeY = -1;
      else if (direction == 3)
        player.changeX = 1;
    } else if (s.equals("back")) {
       time = 17;

      int direction = player.selectDirection();

      if ( direction == 0)
        player.changeY = 1;
      else if (direction == 1)
        player.changeX = -1;
      else if (direction == 2)
        player.changeY = -1;
      else if (direction == 3)
        player.changeX = 1;
       
        player.changeX *= -1;
        player.changeY *= -1;
    }
  }
}

/*
  To add more commands:
 back
 var
 
 */


boolean checkNames(Variable temp, ArrayList<Variable> list)
{
  for (Variable a : list) 
  {
    if (temp.name.equals(a.name)) 
      return true;
  }

  return false;
}

String getVariableName(String temp, ArrayList<Variable> vars)
{
  for (Variable a : vars)
    if (temp.equals(a.name))
      return String.valueOf(a.value);
  return "";
}

ArrayList<String> finalCommands;
void handleExcecution()
{
  finalCommands = new ArrayList<String>();
  ArrayList<Variable> vars = new ArrayList<Variable>();
  String input = text.getText();
  String[] commands = input.split("\\r?\\n?\\s+");

  for (String i : commands)
  {
    print(i + "\n");
  }

  print("\n\n\n");

  int lineInCode = 0;
  for (; lineInCode < commands.length; lineInCode++)
  {

    if (lineInCode != 0 && commands[lineInCode - 1].matches("for|if"))
    {
       while (!commands[lineInCode].equals("end"))
          lineInCode++;
    }
      if (commands[lineInCode].equals("for"))
      {
        Variable temp = new Variable();
        temp.name = commands[++lineInCode];
        ++lineInCode;
        temp.value = Integer.parseInt(commands[++lineInCode]);
        ++lineInCode;
        temp.iterator = true;
        temp.typeOfOperator = commands[++lineInCode];
        temp.bound = Integer.parseInt(commands[++lineInCode]);
        lineInCode += 2;
        if (!checkNames(temp, vars))
          vars.add(temp);
        lineInCode = handleForLoop(lineInCode, commands, vars, temp.bound, temp.name);
      } else if (commands[lineInCode].equals("if"))
      {
        while (!commands[lineInCode].equals("end"))
          lineInCode++;
        //print("Being added in outside if " + commands[lineInCode] + " number " + lineInCode + "\n");
      } else if (commands[lineInCode].equals("int"))
      {
      } else if ( !(commands[lineInCode].equals("for") || commands[lineInCode].equals("if") || commands[lineInCode].equals("end"))  )
      {
        finalCommands.add(commands[lineInCode]);
        //print("Being added in outside " + commands[lineInCode] + " number " + lineInCode + "\n");
      }
    }

    excecute = true;
    //print(vars.size());
    /*for(String s : finalCommands)
     {
     if(s.equals("right")){
     player.angle += 90;
     }else if(s.equals("left")){
     player.angle += 270;
     }else if(s.equals("up")){
     player.angle = 180;
     }else if(s.equals("down")){
     player.angle = 0;
     }else if(s.equals("lookToRight")){
     player.angle = 270;
     }else if(s.equals("lookToLeft")){
     player.angle = 90;
     }else if(s.equals("go")){
     time = 16;
     
     int direction = player.selectDirection();
     
     if( direction == 0)
     player.changeY = 1;
     else if(direction == 1)
     player.changeX = -1;
     else if(direction == 2)
     player.changeY = 1;
     else if(direction == 3)
     player.changeX = 1;
     
     }else if(s.equals("")){
     
     }
     }*/
    for (String s : finalCommands)
    {
      print(s + " ");
    }
  }

  public int handleForLoop(int lineInCode, String[] commands, ArrayList<Variable> vars, int itterations, String usedVariable)
  {
    int StartingLinePosition = lineInCode;
    int returnValue = lineInCode;
    for (int i = 0; i < itterations; i++)
    {
      lineInCode = StartingLinePosition;



      for (; !commands[lineInCode].equals("end"); lineInCode++)
      {
        returnValue = Integer.max(returnValue, lineInCode);
        //print(lineInCode + " ");
        //print(commands[lineInCode]); print(commands[lineInCode].equals("end") + "\n");
        if (commands[lineInCode].equals("end"))
        {
          returnValue = lineInCode;
        }



        if (commands[lineInCode].equals("for"))
        {
          Variable temp = new Variable();
          temp.name = commands[++lineInCode];
          ++lineInCode;
          temp.value = Integer.parseInt(commands[++lineInCode]);
          ++lineInCode;
          temp.iterator = true;
          temp.typeOfOperator = commands[++lineInCode];
          temp.bound = Integer.parseInt(commands[++lineInCode]);
          lineInCode += 2;
          if (!checkNames(temp, vars))
            vars.add(temp);

          lineInCode = handleForLoop(lineInCode, commands, vars, temp.bound, temp.name);
        } else if (commands[lineInCode].equals("if"))
        {
          lineInCode++;
          String eveluatedExpression = "";
          eveluatedExpression += (!commands[lineInCode].equals("i") || !commands[lineInCode].equals("j")) ? getVariableName(commands[lineInCode], vars) : commands[lineInCode];
          eveluatedExpression += " " + commands[++lineInCode] + " " + commands[++lineInCode];
          if (eveluatedExpression.contains("%") || eveluatedExpression.contains("/"))
          {
            eveluatedExpression += " " + commands[++lineInCode] + " " + commands[++lineInCode];
          }

          //print(eveluatedExpression + "\n");
          ///print(lineInCode + " " );
          ScriptEngineManager manager = new ScriptEngineManager();
          ScriptEngine engine = manager.getEngineByName("JavaScript");
          boolean add = false;
          try { 
            add =(boolean)engine.eval(eveluatedExpression);
          } 
          catch (Exception e) {
            print(e);
          }


          lineInCode++;
          while (!commands[lineInCode].equals("end"))
          {
            if (add)
            {
              finalCommands.add(commands[lineInCode]);
              print("Being added " + commands[lineInCode] + " number " + lineInCode + "\n");
            }
            lineInCode++;
          }

          //print(eveluatedExpression + " ");
        } else if (commands[lineInCode].equals("int"))
        {
        } else if ( !(commands[lineInCode].equals("for") || commands[lineInCode].equals("if") || commands[lineInCode].equals("end"))  )
        {
          finalCommands.add(commands[lineInCode]);
          print("Being added in last statment" + commands[lineInCode] + " number " + lineInCode + "\n");
        }
      }

      for (Variable a : vars)
        if (usedVariable.equals(a.name))
          a.value++;
    }
    //print("\nreturn value from handle for loop " + returnValue + "\n");
    return returnValue;
  }


  void mousePressed()
  {
    mousePoint = new Sprite(mouseX, mouseY, 1, 1);
    if (checkCollision(mousePoint, startCommands)) 
    {
      handleExcecution();
    }
  }

  void mouseReleased()
  {
    mousePoint = null;
  }

  ///////Movement
  void keyPressed()
  {

    /**
     Angle
     0 - Down        0
     1 - Left       90
     2 - Up        180 
     3 - Right     270
     
     */
    if (keyCode == RIGHT)
    {
      player.changeX = moveSpeed;
      player.angle =  270;
    } else if (keyCode == LEFT)
    {
      player.changeX = -moveSpeed;
      player.angle = 90;
    } else if (keyCode == UP)
    {
      player.changeY = -moveSpeed;
      player.angle = 180;
    } else if (keyCode == DOWN)
    {
      player.changeY = moveSpeed;
      player.angle = 0;
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
      player.changeY = 0;
    } else if (keyCode == DOWN)
    {
      player.changeY = 0;
    }
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

  void displayAll()
  {
    //for(Sprite s : path)
    //s.display();

    startCommands.display();

    for (Sprite s : obstacles)
      s.display();
    
    for (Sprite s : coins)
    {
       if(checkCollision(player, s))
         //coins.remove(s);
         s.img = null;
         
       if (s.img != null)
         s.display();
    }
    
    player.updateAnimation(); 
    player.display();
    resolvePlatformCollisions(player, obstacles);
    
    
    
  }

  //Adds all tiles from csv file
  void createPlatforms(String filename)
  {
    String[] lines = loadStrings(filename);

    for (int row = 0; row < lines.length; row++)
    {
      String[] values = split(lines[row], ",");
      for (int col = 0; col < values.length; col++)
      {
        int temp = Integer.parseInt(values[col]);
        //print(temp + " ");
        if (temp == -1)
        {
          Sprite s = new Sprite(tiles[0]);
          s.centerX = 8 + col * 16;
          s.centerY = 8 + row * 16;
          path.add(s);
        } else if (temp != 500)
        {
          Sprite s = new Sprite(tiles[temp + 100]);
          s.centerX = 8 + col * 16;
          s.centerY = 8 + row * 16;
          obstacles.add(s);
        } else if (temp == 500) {
          Sprite s = new Sprite(CoinSprite);
          s.centerX = 8 + col * 16;
          s.centerY = 8 + row * 16;
          coins.add(s);
        }
      }
    }
  }

  void loadPlayerSprites(PImage first, PImage second)
  {
    for (int x = 0; x < 3; x++)
    {
      for (int y = 0; y < 4; y++)
      {
        player.walk[x][y] = second.get((16 * y), (32 * x), 16, 32);
      }
      for (int y = 0; y < 4; y++)
        player.idle[x][y] = player.walk[x][1];
    }

    for (int y = 0; y < 4; y++)
    {
      player.walk[3][y] = first.get((16 * y), (32 * 1), 16, 32);
    }

    for (int y = 0; y < 4; y++)
      player.idle[3][y] = player.walk[3][0];
  }

  void makeTiles(PImage img1, PImage img2)
  {

    int counter = 0;
    for (int x = 0; x < 5; x++)
    {
      for (int y = 0; y < 3; y++)
      {
        tiles[counter] = new PImage();
        tiles[counter] = img1.get( (16 * x), (16 * y), 16, 16);
        counter++;
      }
    }

    counter = 100;
    for (int x = 0; x < 4; x++)
    {
      for (int y = 0; y < 4; y++)
      {
        tiles[counter] = new PImage();
        tiles[counter] = img2.get( (16 * y), (16 * x), 16, 16);
        counter++;
      }
    }
  }

  /////Colision detection
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

  //Unesesary? since i don't do jumps
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
    //s.changeY += gravity;
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

  void loadLevel(int level)
  {
    resetPlatforms();
    createPlatforms("Levels/Level" + (level) + ".csv");
  }

  void resetPlatforms()
  {
    obstacles = new ArrayList<Sprite>();
    path = new ArrayList<Sprite>();
    //levelcompletion = new Sprite();
  }
