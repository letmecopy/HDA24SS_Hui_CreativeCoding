/*
Project Name: Deutsch lernen während spielen
Autor: Hui Wang
Matrikelnummer: 1130742
Project concept: 
This game is for those who would like to practice German vocabularies.
User practice the vocabularies in "Practice Mode". The words would appear one by one, users choose the correct meaning among 2 choices.
When they choose the correct answer, they will gain a coin. No coin deduction for wrong answer.
After the user collected 5 coins, they can enter game mode to operate a cat to eat Brezels!
*/

//===============================================  User Practice Mode  ================================================================
/*
1. show coin number
2. show the words 
3. click on correct answer, "Wunderbar!", coin +1
4. click on the wrong answer, "Leider falsch!"
5. every words should be practiced
6. After 5 coins are collected, ask users if they want to enter game mode
*/



class Vocab {
  String word;
  String correctAnswer;
  String wrongAnswer;

  Vocab(String word, String correctAnswer, String wrongAnswer) {
    this.word = word;
    this.correctAnswer = correctAnswer;
    this.wrongAnswer = wrongAnswer;
  }
}

// Array for the vocabularies         New words can be added!
Vocab[] vocabList = {
  new Vocab("rot", "red", "blue"),
  new Vocab("das Buch", "book", "pen"),
  new Vocab("die Informatik", "CS", "Art"),
  new Vocab("die Milch", "milk", "juice"),
  new Vocab("Warum", "why", "what")
};


//Variables decalration
int Index = 0;
boolean correctOnLeft = false;
int practiceCoin = 0;
boolean gameStarted = false;
boolean showFeedback = false;
boolean correct = false;
int feedbackStartTime = 0;
int feedbackDuration = 1000;
boolean inGameMode = false;


PImage playerImg;
PImage img;


float groundY = 600;
float square = 50;
float playerX = 0;
float playerY = 550;
float playerSpeedX = 0;
float playerSpeedY = 0;


//two Brezels
float brezel1X = 500;
float brezel1Y = 540;

float brezel2X = 800;
float brezel2Y = 450;


//Obstacles
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

//============================= setup =======================================
void setup() {
  size(1000, 800);
  textAlign(CENTER, CENTER);
  textSize(32);
  
  playerImg = loadImage("cat.png");
  img = loadImage("Brezel.jpg");

}

//============================  draw  =======================================
void draw() {
  background(255);

  // coin hint
  fill(0);
  textAlign(LEFT);
  textSize(42);
  text("Coins: " + practiceCoin, 10, 50);


  if (inGameMode) {
    runGameMode();
  } 
  else if (practiceCoin >= 5) {
    displayCoinMessage();
  } 
  else if (gameStarted) {
    if (showFeedback) {
      displayFeedback();
      if (millis() - feedbackStartTime > feedbackDuration) {
        showFeedback = false;
        nextWord();
      }
    } else {
      displayWordAndButtons();
    }
  } else {
    displayStartButton();
  }
}

void displayStartButton() {
  // start button
  stroke(0);
  fill(50, 123, 90);
  strokeWeight(5);
  rect(400, 300, 150, 60);
  fill(255);
  text("START",420, 345);
}

// display the current word, from the Array
void displayWordAndButtons() {
  Vocab vocab = vocabList[Index];

  // Word
  fill(0, 128, 255);
  text(vocab.word, width / 2 - 60, 200);

  if (correctOnLeft) {
    drawButton(vocab.correctAnswer, 250, 400);
    drawButton(vocab.wrongAnswer, 600, 400);
  } else {
    drawButton(vocab.wrongAnswer, 250, 400);
    drawButton(vocab.correctAnswer, 600, 400);
  }
}

void drawButton(String label, int x, int y) {
  stroke(0);
  fill(255);
  rect(x, y, 150, 60);
  fill(0);
  text(label, x + 40, y + 40);
}

void displayFeedback() {
  if (correct) {
    fill(0, 255, 0);
    text("Wunderbar!", width / 2 - 90, height / 2);
  } else {
    fill(255, 0, 0);
    text("Leider falsch!", width / 2 - 90, height / 2);
  }
}

void mousePressed() {
  if (!gameStarted) {
    if (mouseX >= 400 && mouseX <= 550 && mouseY >= 300 && mouseY <= 360) {
      gameStarted = true;
      showFeedback = false;
      Index = 0;
      nextWord();
    }
  } else if (!showFeedback) {
    Vocab vocab = vocabList[Index];
    if ((correctOnLeft && mouseX >= 250 && mouseX <= 400 && mouseY >= 400 && mouseY <= 460) ||
        (!correctOnLeft && mouseX >= 600 && mouseX <= 750 && mouseY >= 400 && mouseY <= 460)) {
      // coin +1
      practiceCoin++;
      correct = true;
    } else if ((correctOnLeft && mouseX >= 600 && mouseX <= 750 && mouseY >= 400 && mouseY <= 460) ||
               (!correctOnLeft && mouseX >= 250 && mouseX <= 400 && mouseY >= 400 && mouseY <= 460)) {
      correct = false;
    }
    showFeedback = true;
    feedbackStartTime = millis();
  }

  if (practiceCoin >= 5 && mouseX >= 400 && mouseX <= 550 && mouseY >= 300 && mouseY <= 360) {
    inGameMode = true;
    gameStarted = false; // Stop practice mode
  }
}

void nextWord() {
  Index++;
  if (Index >= vocabList.length) {
    Index = 0;
  }
  correctOnLeft = random(1) < 0.5;
}

void displayCoinMessage() {
  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("You have collected 5 coins. Enter Game Mode?", width / 2, 200);

  // YES button
  stroke(0);
  fill(50, 123, 90);
  strokeWeight(5);
  rect(400, 300, 150, 60);
  fill(255);
  textSize(50);
  text("YES", 475, 350);
}

void runGameMode() {
  // draw the player image
  image(playerImg, playerX, playerY, 56, 56);//original position of cat

  // draw the ground
  fill(0, 139, 139);
  rect(0, 600, 1000, 200);

  // gravity
  if (!gameOver && !gameWon) {
    playerSpeedY += gravity;
  }

  // Player move
  // horizontal: ->  -<  vertical: gravity
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

  //// Display coins count
  //fill(0);
  //textSize(50);
  //textAlign(LEFT);
  //text("Score: " + score, 20, 50);

  // Display win message
  if (gameWon) {
    fill(0);
    textSize(50);
    textAlign(CENTER);
    text("You win!", width / 2, height / 2);
  }
}

void keyPressed() {
  if (inGameMode) {
    if (key == ' ') {
      if (!gameOver && !jumping && playerY + square >= groundY) {
        playerSpeedY = -15;
        jumping = true;
      }
    } else if (key == CODED) {
      if (keyCode == LEFT) {
        playerSpeedX = max(playerSpeedX - 1, -5); // 最小速度限制为 -5
      } else if (keyCode == RIGHT) {
        playerSpeedX = min(playerSpeedX + 1, 5); // 最大速度限制为 5
      }
    }
  }
}

void keyReleased() {
  if (inGameMode && (keyCode == LEFT || keyCode == RIGHT)) {
    playerSpeedX = 0; // Stop player horizontal movement when key is released
  }
}
