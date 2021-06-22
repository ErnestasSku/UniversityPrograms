class Sprite
{
   PImage img;
   float centerX, centerY;
   float changeX, changeY;
   float w, h;
   int imageNumber;
   
    Sprite(String filename, float scale, float x, float y)
    {
       img = loadImage(filename);
       h = img.height * scale;
       w = img.width * scale;
       centerX = x;
       centerY = y;
       changeX = 0;
       changeY = 0;
       imageNumber = -1;
    }
    
    Sprite(String filename, float scale)
    {
       this(filename, scale, 0, 0); 
    }
    Sprite(float h, float w)
    {
       this.h = h;
       this.w = w;
       centerX = 0;
       centerY = 0;
       changeX = 0;
       changeY = 0;
       imageNumber = -1;
    }
    
 
    Sprite(PImage img)
    {
        this.img = img;
        h = 32;
        w = 32;
        centerX = 0;
        centerY = 0;
        changeX = 0;
        changeY = 0;
    }
    
    Sprite(PImage img, float posX, float posY)
    {
        this.img = img;
        h = 32;
        w = 132;
        centerX = posX;
        centerY = posY;
        changeX = 0;
        changeY = 0;
    }
    Sprite(float posX, float posY, float w, float h)
    {
        img = null;
        this.h = w;
        this.w = h;
        centerX = posX;
        centerY = posY;
        changeX = 0;
        changeY = 0;
    }
    Sprite()
      {
         img = null;
        this.h = w;
        this.w = h;
        centerX = 0;
        centerY = 0;
        changeX = 0;
        changeY = 0; 
    }
     
    void display()
    {
        if(img != null)
          image(img, centerX, centerY, w, h); 
    }
     
    void update()
    {
      
       centerX += changeX;
       centerY += changeY;
    }
    
    float getLeft()
    {
        return centerX - w/2;
    }
    
    void setLeft(float Left)
    {
       centerX = Left + w/2; 
    }
    
    float getRight()
    {
        return centerX + w/2;
    }
    
    void setRight(float Right)
    {
       centerX = Right - w/2; 
    }
    
    float getBottom()
    {
       return centerY + h/2; 
    }
    
    void setBottom(float bottom)
    {
      centerY = bottom - h/2;
    }
    
    float getTop()
    {
      return centerY - h/2;
    }
    void setTop(float top)
    {
       centerY = top + h/2;
    }
    

    
}
