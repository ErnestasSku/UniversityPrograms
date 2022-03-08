class Player extends Sprite 
{
    /**
      Angle
      0 - Down        0
      1 - Left       90
      2 - Up        180 
      3 - Right     270
    
    */
    int angle = 0, direction, frame = 0, index = 0, actualW = 16, actualH = 32;
    PImage walk[][];
    PImage idle[][];
    PImage[] currentAnimation;
    
    Player(float right, float left)
    {
       super(right, left); 
    }
    
    void updateAnimation()
    {
       frame++;
       if(frame % 2 == 0) 
       {
          selectDirection();
          selectCurrentAnimation();
          changeToNext();
       }
       
       if (frame >= 10000000)
           frame = 0;
    }
    
    int selectDirection() 
    {
      angle = angle % 360;
      return direction = angle / 90;
    }
    
    void selectCurrentAnimation()
    {
       if(changeX == 0 && changeY == 0)
       {
         currentAnimation = idle[selectDirection()];
       } else {
         currentAnimation = walk[selectDirection()];
       }
    }
    
    void changeToNext()
    {
      index++;
      if(index >= 4)
        index = 0;
       img = currentAnimation[index];
    }
 

   void display()
   {
     if(img != null)
          image(img, centerX, centerY, actualW, actualH);
   }
   
}
