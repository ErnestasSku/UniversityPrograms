class Player extends Sprite
{
  
    //int lives;
    
    //0 left, 1 right;
    int direction, frame = 0, index = 0;
    PImage[][] idle;
    PImage[][] run;
    PImage[][] jump;
    PImage[] currentAnimation;
    
    Player(float right, float left)
    {
       super(right, left);
       //lives = 3;
    }
    
    void updateAnimation()
    {
        frame++;
        if(frame % 5 ==0)
        {
            selectDirection();
            selectCurrentAnimation();
            changeToNext();
        }
        
        //display();
        if(frame == 1000000)
          frame = 0;
    }
    /*
        if x != 0 run
        if y != 0 jump
    */
    void selectDirection()
    {
        if(changeX > 0)
          direction = 1;
        else if(changeX < 0)
          direction = 0;
    }
    void selectCurrentAnimation()
    {
        if(changeY != 0)
        {
           currentAnimation = jump[direction];  
        }else if(changeX != 0){
           currentAnimation = run[direction]; 
        }else{
           currentAnimation = idle[direction]; 
        }
    }
    
    void changeToNext()
    {
       index++;
       if(index >= 6)
       {
          index = 0; 
       }
       img = currentAnimation[index];
    }
    
}
