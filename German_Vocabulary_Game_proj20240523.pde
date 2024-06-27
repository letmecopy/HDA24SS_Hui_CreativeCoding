
PImage img;
float groundY = 600;
float square = 50;
float playerX = 0;
float playerY = 600 - square;
float playerSpeedX = 0;
float playerSpeedY = 0;

float brezel1X = 500;
float brezel1Y = 550;

float obstacleRectX = 300;
float obstacleRectY = 570;
float obstacleRectWidth = 50;
float obstacleRectHeight = 30;

float gravity = 0.98;
int score = 0;

boolean gameOver = false;

//only allow jumping when the player is not already jumping
boolean jumping = false;


void setup(){
  size(1000,800);
  textSize(50);
  textAlign(LEFT);
  img = loadImage("Brezel.jpg");
  
  
}

void draw(){
  background(255);
  
  
  //left corner hint about coins
  fill(0);
  text("Coins:" + score, 0, 50);
  
  
  //draw the ground
  //stroke(0);
  //strokeWeight(4);
  //line(0, groundY, width, groundY);
  fill(0,139,139);
  rect(0,600,1000,200);
  
  //move the player
  playerY += playerSpeedY;
  
  //the picture of Brezels
  image(img,brezel1X,brezel1Y,50,50);
  fill(54,100,139);
  rect(obstacleRectX,obstacleRectY,obstacleRectWidth,obstacleRectHeight);
  
  
  if(keyPressed && key == CODED){
    
    if (!gameOver) {
       if(keyCode == LEFT){
      playerX -= 20;
      }else if(keyCode == RIGHT){
        playerX += 20;
      }else if(keyCode == UP){
        playerY -= 20;
      }else if(keyCode == DOWN){
        playerY += 20;
      }
    }
    

  }
  
  
  //==================   collision detection with obstacles   ===========================
  if(playerX + square > obstacleRectX && playerX < obstacleRectX + obstacleRectWidth && playerY + square > obstacleRectY){
    text("Game Over", 300,200);
    gameOver = true;
  }
  
  
  //==================   collision detection with awards   ==============================
  if(playerX == brezel1X){ //to be changed 
    score += 1;
    //text("You have won a coin!", 300,200);
    brezel1X = 1000000;//throw away the first Brezel
  }
  
  
  
  fill(255,127,0);
  rect(playerX, playerY, square, square);
  saveFrame("Shape.png");
}
