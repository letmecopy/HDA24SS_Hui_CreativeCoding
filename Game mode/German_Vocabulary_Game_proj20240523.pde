//Game Mode


PImage playerImg; 
PImage img;
//PImage obstacleImg;

float groundY = 600;
float square = 50;
float playerX = 0;
float playerY = 550;
float playerSpeedX = 0;
float playerSpeedY = 0;

float brezel1X = 500;
float brezel1Y = 550;

float brezel2X = 800;
float brezel2Y = 450;

float obstacleRect1X = 300;
float obstacleRect1Y = 570;
float obstacleRectWidth = 30;
float obstacleRectHeight = 30;

float obstacleRect2X = 800;
float obstacleRect2Y = 570;

float gravity = 0.98;
int score = 0;

boolean gameOver = false;
boolean jumping = false;
boolean gameWon = false;



void setup() {
  size(1000, 800);
  textSize(50);
  textAlign(LEFT);
  img = loadImage("Brezel.jpg");
  playerImg = loadImage("cat.png");
  //obstacleImg = loadImage("obstacle.png");
}



void draw() {
  background(255);
  
  // draw the player image
  image(playerImg, playerX, playerY, 58, 58); 
  
  // draw the ground
  fill(0, 139, 139);
  rect(0, 600, 1000, 200);

  //gravity
  if (!gameOver && !gameWon) {
    playerSpeedY += gravity;
  }

  // Player move 
  //horizontal: ->  -<  vertical: gravity
  playerX += playerSpeedX;
  playerY += playerSpeedY;

  // the picture of Brezels
  image(img, brezel1X, brezel1Y, 50, 50);
  image(img, brezel2X, brezel2Y, 50, 50);

  fill(54, 100, 139);
  rect(obstacleRect1X, obstacleRect1Y, obstacleRectWidth, obstacleRectHeight);
  rect(obstacleRect2X, obstacleRect2Y, obstacleRectWidth, obstacleRectHeight);

  // handle horizontal movement
  if (!gameOver && !gameWon) {
    if (keyPressed && key == CODED) {
      if (keyCode == LEFT) {
        playerSpeedX = max(playerSpeedX - 1, -5); // 最小速度限制为 -5
      } else if (keyCode == RIGHT) {
        playerSpeedX = min(playerSpeedX + 1, 5); // 最大速度限制为 5
      }
    }
  }

  // handle jumping
  if (keyPressed && key == ' ') {
    if (!gameOver && !jumping && playerY + square >= groundY) {
      playerSpeedY = -15;
      jumping = true;
    }
  }

  // collision with ground
  if (playerY + square >= groundY) {
    playerY = groundY - square;
    playerSpeedY = 0;
    jumping = false;
  }

  // collision detection with obstacles
  if ((playerX + square > obstacleRect1X && playerX < obstacleRect1X + obstacleRectWidth && playerY + square > obstacleRect1Y) ||
      (playerX + square > obstacleRect2X && playerX < obstacleRect2X + obstacleRectWidth && playerY + square > obstacleRect2Y)) {
    text("Game Over", 300, 200);
    gameOver = true;
  }

  // collision detection with awards
  if ((playerX + square > brezel1X && playerX < brezel1X + 50 && playerY + square > brezel1Y && playerY < brezel1Y + 50) ||
      (playerX + square > brezel2X && playerX < brezel2X + 50 && playerY + square > brezel2Y && playerY < brezel2Y + 50)) {
    score += 1;
    if (playerX + square > brezel1X && playerX < brezel1X + 50 && playerY + square > brezel1Y && playerY < brezel1Y + 50) {
      brezel1X = 1000000; // throw away the first Brezel
    }
    if (playerX + square > brezel2X && playerX < brezel2X + 50 && playerY + square > brezel2Y && playerY < brezel2Y + 50) {
      brezel2X = 1000000; // throw away the second Brezel
    }
  }

  // Check if all Brezels are collected and player reaches the right edge
  if (brezel1X == 1000000 && brezel2X == 1000000 && playerX + square >= width) {
    gameWon = true;
  }

  // Display coins count
  fill(0);
  textSize(50);
  textAlign(LEFT);
  text("Score: " + score, 20, 50);

  // Display win message
  if (gameWon) {
    fill(0);
    textSize(50);
    textAlign(CENTER);
    text("You win!", width / 2, height / 2);
  }
}

void keyPressed() {
  if (key == ' ') {
    if (!gameOver && !jumping && playerY + square >= groundY) {
      playerSpeedY = -15;
      jumping = true;
    }
  }
}

void keyReleased() {
  // No need to handle key release for left/right keys, let the playerSpeedX maintain its value until next key press
}
