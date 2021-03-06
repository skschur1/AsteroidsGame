SpaceShip heart_of_gold = new SpaceShip();
boolean [] keys = new boolean[6];
Star [] stars = new Star[100];
ArrayList <Asteroid> rocks = new ArrayList <Asteroid>();
ArrayList <Bullet> pewPew = new ArrayList <Bullet>();
boolean crashed = false;
boolean shootingStability = true;
int framecount = 0;
int score = 0;
int health = 5;
int ammo = 10;
public void setup() 
{
  size(600, 600);
  background(0);
  for (int i = 0; i < keys.length; i++)
    keys[i] = false;
  for (int o = 0; o < stars.length; o++)
    stars[o] = new Star();
  for (int u = 0; u < 10; u++)
  {
    rocks.add(new Asteroid());
    if (dist(rocks.get(u).getX(), rocks.get(u).getY(), heart_of_gold.getX(), heart_of_gold.getY()) < 50)
      rocks.get(u).respawn();
  }
}
public void draw() 
{
  background(0);
  if (crashed)
  {
    fill(255);
    textAlign(CENTER,CENTER);
    text("Game Over", width / 2, height /2 );
    text("Score: " + score, width /2, height / 2 + 15);
    textAlign(BASELINE);
  }
  else
  {
    if (rocks.size() == 0)
    {
      for(int i = 0; i < 11; i++)
        rocks.add(new Asteroid());
    }
    for (int i = 0; i < pewPew.size(); i++)
    {
      pewPew.get(i).move();
      pewPew.get(i).show();
      if (pewPew.get(i).getX() > 600 || pewPew.get(i).getX() < 0 || pewPew.get(i).getY() < 0 || pewPew.get(i).getY() > 600)
      {
        pewPew.remove(i);
        i--;
      }

    }
    for (int i = 0; i < rocks.size(); i++)
    {
      rocks.get(i).move();
      rocks.get(i).show();
      if (rocks.get(i).crash())
      {
        rocks.remove(i);
        i--;
        health--;
        if (health <= 0)
          crashed = true;
        score--;
      }
      while (i < 0)
        i++;
      if (rocks.size() > 0)
      {
        if (rocks.get(i).destroy())
        {
          rocks.remove(i);
          score++;
          i--;
        }
      }
    }
    for (int u = 0; u < stars.length; u++)
      stars[u].show();
    heart_of_gold.move();
    if (keys[0])
      heart_of_gold.accelerate(0.25);
    if (keys[1])
      heart_of_gold.accelerate(-0.25);
    if (keys[2])
      heart_of_gold.rotate(-4);
    if (keys[3])
      heart_of_gold.rotate(4);
    if (keys[4])
    {
      heart_of_gold.improbabilityDrive();
      for(int i = 0; i < stars.length; i++)
        stars[i].reposition();
      for(int i = 0; i < rocks.size(); i++)
        rocks.get(i).respawn();
      while (pewPew.size() > 0)
        pewPew.remove(0);
    }
    if (keys[5])
    {
      if (framecount % 10 == 0 && ammo > 0)
      {
        heart_of_gold.shoot();
        ammo--;
      } 
    }
    if (!keys[5])
    {
      if (framecount % 10 == 0 && ammo < 10)
        ammo++;

    }
    framecount++;
    heart_of_gold.show();
    strokeWeight(3);
    stroke(100);
    rect(0, 550, 103 , 45);
    noStroke();
    fill(255, 0, 0);
    rect(45, 586, 50, 8);
    rect(45, 571, 50, 9);
    fill(242, 223, 56);
    rect(45, 586, ammo * 5, 8);
    fill(0, 255 , 0);
    rect(45, 571, health * 10, 9);
    fill(0);
    text("Ammo: " + ammo, 5, 595);
    text("Health: " + health, 5, 580);
    text("Score: " + score, 5, 565);
    strokeWeight(1);
  }
}
public void keyPressed()
{
  if (key == 'w')
    keys[0] = true;
  if (key == 's')
    keys[1] = true;
  if (key == 'a')
    keys[2] = true;
  if (key == 'd')
    keys[3] = true;
  if (key == 'e')
    keys[4] = true;
  if (key == ' ')
  {
    keys[5] = true;
    if (shootingStability)
    {
      framecount = 0;
      shootingStability = false;
    }
  }
}
public void keyReleased()
{
    if (key == 'w')
    keys[0] = false;
  if (key == 's')
    keys[1] = false;
  if (key == 'a')
    keys[2] = false;  
  if (key == 'd')
    keys[3] = false;
  if (key == 'e')
    keys[4] = false;
  if (key == ' ')
  {
    keys[5] = false;
    if (!shootingStability)
    {
      framecount = 0;
      shootingStability = true;
    }
  }
}
public void mouseClicked()
{
  if (crashed)
  {
    crashed = false;
    for (int s = 0; s < rocks.size(); s++)
    {
      rocks.get(s).respawn();
      stars[s].reposition();
    }
      heart_of_gold.setX(300);
      heart_of_gold.setY(300);
      heart_of_gold.setDirectionY(0);
      heart_of_gold.setDirectionX(0);
      heart_of_gold.setPointDirection(0);
      health = 5;
      ammo = 10;
      score = 0;
      while (pewPew.size() > 0)
        pewPew.remove(0);
      while (rocks.size() > 0)
        rocks.remove(0);
  }
}
class SpaceShip extends Floater  
{   
    public SpaceShip()
    {
      corners = 4;
      xCorners = new int[4];
      yCorners = new int[4];
      xCorners[0] = 5;
      yCorners[0] = 0;
      xCorners[1] = -5;
      yCorners[1] = 5;
      xCorners[2] = -2;
      yCorners[2] = 0;
      xCorners[3] = -5;
      yCorners[3] = -5;
      myColor = color(255);
      myCenterX = myCenterY = 300;
      myPointDirection = 0;
      myDirectionX = myDirectionY = 0;
    }
    public void setX(int x) {myCenterX = x;}
    public int getX() {return (int) myCenterX;}
    public void setY(int y) {myCenterY = y;}  
    public int getY() {return (int) myCenterY;}  
    public void setDirectionX(double x) {myDirectionX = x;}   
    public double getDirectionX() {return myDirectionX;}
    public void setDirectionY(double y) {myDirectionY = y;}
    public double getDirectionY() {return myDirectionY;}
    public void setPointDirection(int degrees) {myPointDirection = degrees;}
    public double getPointDirection() {return myPointDirection;}
    public void improbabilityDrive()
    {
      setX((int)(Math.random()*600));
      setY((int)(Math.random()*600));
      setDirectionY(0);
      setDirectionX(0);
      setPointDirection((int)(Math.random()*360));
    }
    public void shoot()
    {
      pewPew.add(new Bullet(heart_of_gold.getX(), heart_of_gold.getY(), heart_of_gold.getPointDirection(), heart_of_gold.getDirectionX(), heart_of_gold.getDirectionY()));
    }
  }
class Bullet extends Floater
{
  public Bullet(int x, int y, double pointDirection, double directionX, double directionY)
  {
    corners = 4;
    xCorners = new int[4];
    yCorners = new int[4];
    xCorners[0] = 2;
    yCorners[0] = 0;
    xCorners[1] = 0;
    yCorners[1] = 2;
    xCorners[2] = -2;
    yCorners[2] = 0;
    xCorners[3] = 0;
    yCorners[3] = -2;
    myColor = color(255);
    myCenterX = x;
    myCenterY = y;
    myPointDirection = pointDirection;
    myDirectionX = directionX;
    myDirectionY = directionY;
    accelerate(5);
  }
  public void setX(int x) {myCenterX = x;}
  public int getX() {return (int)myCenterX;}
  public void setY(int y) {myCenterY = y;}
  public int getY() {return (int)myCenterY;}
  public void setDirectionX(double x) {myDirectionX = x;}   
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY = y;}
  public double getDirectionY() {return myDirectionY;}
  public void setPointDirection(int degrees) {myPointDirection = degrees;}
  public double getPointDirection() {return myPointDirection;}
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY; 
  }
}
class Asteroid extends Floater
{
  int rotSpeed;
  public Asteroid()
  {
    corners = 11;
    xCorners = new int[11];
    yCorners = new int[11];
    xCorners[0] = 10;
    yCorners[0] = 0;
    xCorners[1] = 7;
    yCorners[1] = -4;
    xCorners[2] = 0;
    yCorners[2] = -10;
    xCorners[3] = -6;
    yCorners[3] = -8;
    xCorners[4] = -8;
    yCorners[4] = -3;
    xCorners[5] = -10;
    yCorners[5] = 0;
    xCorners[6] = -5;
    yCorners[6] = 5;
    xCorners[7] = 0;
    yCorners[7] = 10;
    xCorners[8] = 3;
    yCorners[8] = 11;
    xCorners[9] = 6;
    yCorners[9] = 9;
    xCorners[10] = 9;
    yCorners[10] = 5;
    myColor = color(137, 84, 15);
    rotSpeed = (int)(Math.random()*11 - 6);
    respawn();
  }
  public void respawn()
  {      
    myCenterX = Math.random()*600;
    myCenterY = Math.random()*600;
    myDirectionX = Math.random()*4 - 2;
    myDirectionY = Math.random()*4 -2;
    myPointDirection = Math.random()*360;
    if (dist((int)myCenterX,(int) myCenterY, heart_of_gold.getX(), heart_of_gold.getY()) < 50)
      respawn();
  }
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY  
    rotate(rotSpeed);
    super.move();
  }
  public boolean crash()
  {
    if (dist((int)myCenterX, (int)myCenterY, (int)heart_of_gold.getX(),(int) heart_of_gold.getY()) < 20)
      return true;
    else 
      return false;
  }
  public boolean destroy()
  {
    for (int i = 0; i < pewPew.size(); i++)
      if (dist((int)myCenterX, (int)myCenterY, pewPew.get(i).getX(), pewPew.get(i).getY()) < 15)
        return true;
    return false;
  }
  public void setX(int x) {myCenterX = x;}
  public int getX() {return (int)myCenterX;}
  public void setY(int y) {myCenterY = y;}
  public int getY() {return (int)myCenterY;}
  public void setDirectionX(double x) {myDirectionX = x;}   
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY = y;}
  public double getDirectionY() {return myDirectionY;}
  public void setPointDirection(int degrees) {myPointDirection = degrees;}
  public double getPointDirection() {return myPointDirection;}
}
abstract class Floater //Do NOT modify the Floater class! Make changes in the SpaceShip class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    
  abstract public void setX(int x);  
  abstract public int getX();   
  abstract public void setY(int y);   
  abstract public int getY();   
  abstract public void setDirectionX(double x);   
  abstract public double getDirectionX();   
  abstract public void setDirectionY(double y);   
  abstract public double getDirectionY();   
  abstract public void setPointDirection(int degrees);   
  abstract public double getPointDirection(); 

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));       
  }   
  public void rotate (int nDegreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=nDegreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if(myCenterX >width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY >height)
    {    
      myCenterY = 0;    
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = height;    
    }   
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   
} 
class Star
{
  private int myX, myY;
  public Star()
  {
    reposition();
  }
  public void show()
  {
    strokeWeight(1);
    stroke(255);
    point(myX, myY);
    stroke(0);
  }
  public void reposition()
  {
    myX = (int)(Math.random()*600);
    myY = (int)(Math.random()*600);
  }
}