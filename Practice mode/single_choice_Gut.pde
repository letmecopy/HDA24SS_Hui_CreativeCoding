//User Practice Mode
/*
1. show coin number
2. show the word
3. click on correct answer, "Wunderbar!", coin +1
4. click on the wrong answer, "Leider falsch!"
5. every words should be practiced
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


//an Array for the vocabularies
Vocab[] vocabList = {
  new Vocab("Rot", "red", "blue"),
  new Vocab("Buch", "book", "pen"),
  new Vocab("Informatik", "CS", "Art")
};


int Index = 0;
boolean correctOnLeft = false;
int practiceCoin = 0;
boolean gameStarted = false;
boolean showFeedback = false;
boolean correct = false;
int feedbackStartTime = 0;
int feedbackDuration = 1000; 


//============================= setup =======================================
void setup() {
  size(1000, 800);
  textAlign(CENTER, CENTER);
  textSize(32);
}


//============================  draw  =======================================
void draw() {
  background(255);

  // coin instruction
  fill(0);
  textAlign(LEFT);
  textSize(42);
  text("Coins: " + practiceCoin, 10, 50);


  //user click START and then show the word
  if (gameStarted) {
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
  //start button
  stroke(0);
  fill(50,123,90);
  strokeWeight(5);
  rect(400, 300, 150, 60);
  fill(255);
  text("START", 420, 345);
}


//display the current word, from the Array
void displayWordAndButtons() {
  Vocab vocab = vocabList[Index];

  // Word
  fill(0,128,255);
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
}

void nextWord() {
  Index++;
  if (Index >= vocabList.length) {
    // 
    Index = 0;
  }
  
  correctOnLeft = random(1) < 0.5;
}
