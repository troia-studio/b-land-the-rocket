import processing.sound.*;

Traveller t;
Platform[] platforms;

PImage bg;
SoundFile fireSoundL;
SoundFile fireSoundR;
boolean isLPlaying = false;
boolean isRPlaying = false;

float[] yValues = new float[180];

float startY;
int highScore = 0;

void setup() {
  size(600, 900, P2D);
  frameRate(60);
  imageMode(CENTER);

  t = new Traveller();
  startY = t.pos.y;

  platforms = new Platform[100];

  for (int  i = 0; i < platforms.length; i++) {
    float gap = 400;

    float y;
    if (i == 0) {
      y = t.pos.y + t.h * 0.5 + 50 * 0.5 + 2;
    } else {
      y = platforms[i - 1].pos.y - gap;
    }

    float x;
    if (i == 0) {
      x = t.pos.x;
    } else {
      x = random( t.pos.x - 300, t.pos.x + 300 );
    }

    platforms[i] = new Platform(new PVector(x, y), 150, 50);
  }

  bg = loadImage("data/bg.png");
  fireSoundL = new SoundFile(this, "data/fire_sound.wav");
  fireSoundL.amp(0.1);
  fireSoundR = new SoundFile(this, "data/fire_sound.wav");
  fireSoundR.amp(0.1);
 

  for (int i = 0; i < yValues.length; i++) {
    //float gap = height * 0.5 - t.h * 0.5;
    float y = random(height * 0.7, height* 0.9);
    yValues[i] = y;
  }
}

void draw() {
  pushMatrix();
  translate(-t.pos.x + width * 0.5, -t.pos.y + height * 0.5);
  
  // I have added parallax effect by moving bg little bit with the rocket
  pushMatrix();
  translate(t.pos.x * 0.3, t.pos.y * 0.3);
  for (int i = -5; i < 5; i++) {
    for (int j = -5; j < 5; j++) {
      image(bg, i*bg.width, j * bg.height);
    }
  }
  popMatrix();

  fill(0, 150);
  rect(-width * 15, -height * 15, width*30, height *30);

  beginShape();

  fill(noise(yValues.length - 1) * 255);
  curveVertex(15 * width, height * 1.3);
  fill(noise(0) * 255);
  curveVertex(-15 * width, height * 1.3);

  for (int i = 0; i < yValues.length; i++) {
    float ratio = i / (yValues.length - 1.0);
    float x = -15 * width + ratio * 30 * width;

    colorMode(HSB);
    fill(10, 80, 100 + 40 * noise(i));
    colorMode(RGB);
    curveVertex(x, yValues[i]);
  }

  fill(noise(yValues.length - 1) * 255);
  curveVertex(15 * width, height * 1.3);
  fill(noise(yValues.length / 2) * 255);
  curveVertex(0, height * 1.3);
  fill(noise(0) * 255);
  curveVertex(-15 * width, height * 1.3);

  endShape();

  for (int i = 0; i < platforms.length; i++) {
    platforms[i].show();
    checkLanded(platforms[i]);
    checkCrash(platforms[i]);
  }

  t.applyForce();
  t.useFuel();
  t.move();
  t.show();

  popMatrix();

  noFill();
  strokeWeight(20);
  stroke(45, 200, 160);
  float degree = t.totalFire * (-36.0 / (t.fireLimit * 0.1));
  arc(width-70, 70, 70, 70, radians(-360), radians(degree));
  noStroke();

  fill(255, 150);
  textSize(50);

  int currentScore = round((startY - t.pos.y) / 10) * 10;
  if (currentScore > highScore) {
    highScore = currentScore;
  }

  text(highScore, 40, 70);

  if (t.isDead) {
    fill(30, 200);
    rect(0, 0, width, height);
    fill(255);
    textSize(60);
    textAlign(CENTER);
    text("GAME OVER", width * 0.5, height * 0.5);
    text("SCORE: " + highScore, width * 0.5, height * 0.5 + 80);

    noLoop();
  }
}

float ground(float x) {
  float ratio= (x + 15 * width ) / (30.0 * width);
  float i =  ratio * (yValues.length - 1.0);

  int startIndex = floor(i);
  int endIndex = ceil(i);
  float decimal = i - startIndex;

  // endIndex should not exceed yValues length, in case use the last valid value
  if (endIndex >= yValues.length) {
    return yValues[yValues.length-1];
  }

  float ground = yValues[startIndex] * (1.0 - decimal)  + yValues[endIndex] * decimal;

  return ground;
}

void checkCrash(Platform p) {
  boolean isInsideYEnd =  p.pos.y + p.h * 0.5 + t.h * 0.5 > t.pos.y;
  boolean isInsideYStart = t.pos.y >  p.pos.y- p.h * 0.5 - t.h * 0.5 + 4;
  boolean isInsideXEnd = p.pos.x + p.w * 0.5 + t.w * 0.3 > t.pos.x;
  boolean isInsideXStart =p.pos.x - p.w * 0.5 - t.w * 0.3 < t.pos.x;

  if ( isInsideYEnd && isInsideYStart && isInsideXEnd && isInsideXStart) {
    t.isDead = true;
  }
}

void checkLanded(Platform p) {
  float targetY = p.pos.y - p.h * 0.5 - t.h * 0.5;
  float targetXStart = p.pos.x - p.w * 0.5;
  float targetXEnd = p.pos.x + p.w * 0.5;

  boolean isYCorrect =  t.pos.y + 2 > targetY && t.pos.y - 2 < targetY;
  boolean isXCorrect = t.pos.x < targetXEnd && t.pos.x > targetXStart;

  if ( isYCorrect && isXCorrect) {
    if (t.vel.y > 2) {
      t.isDead = true;
    } else {
      if (t.totalFire > 0) {
        t.totalFire -= 3;
      }

      t.vel = new PVector(0, 0);
      t.pos.y = targetY - 2;
    }
  }
}

void keyPressed() {
  if (key == 'a') {
    t.isLeftPressing = true;
    if (isLPlaying == false && t.totalFire <= t.fireLimit && t.isDead == false) {
      fireSoundL.play();
      isLPlaying = true;
    }
  }
  
  if (key == 'd') {
    t.isRightPressing = true;
    if (isRPlaying == false && t.totalFire <= t.fireLimit && t.isDead == false) {
      fireSoundR.play();
      isRPlaying = true;
    }
  }
}

void keyReleased() {
  if (key == 'a') {
    t.isLeftPressing = false;
    fireSoundL.jump(1);
    fireSoundL.pause();
    isLPlaying = false;
  }
  if (key == 'd') {
    t.isRightPressing = false;
    fireSoundR.jump(1);
    fireSoundR.pause();
    isRPlaying = false;
  }
}
