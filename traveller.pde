class Traveller {
  PImage body;
  FireGas fireLeft;
  FireGas fireRight;
  PVector pos;
  PVector vel;
  PVector acc;
  int w = 100;
  int h = 165;
  boolean isLeftPressing = false;
  boolean isRightPressing = false;
  float speed = 0.03;
  int totalFire = 0;
  int fireLimit = 450;

  boolean isDead = false;
  boolean isLanded = false;
  boolean checkCrash = false;

  Traveller() {
    body = loadImage("data/rocket.png");
    body.resize(w, h);
    
    pos = new PVector(width * 0.1, height *0.5);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
      
    float fireLeftX = pos.x - w*0.35;
    float fireRightX = pos.x + w*0.35;
    float fireY = pos.y + h*0.5;
    
    fireLeft = new FireGas(new PVector(fireLeftX, fireY));
    fireRight = new FireGas(new PVector(fireRightX, fireY));
  }

  void useFuel() {
    if (isLeftPressing) {
      totalFire ++;
    }

    if (isRightPressing) {
      totalFire ++;
    }
  }

  void show() {
    image(body, pos.x, pos.y);
    fireLeft.show();
    fireRight.show();
    
    fireLeft.cease();
    fireRight.cease(); 
    
    
}

  void applyForce() {
    float fireLeftX = pos.x - w*0.35;
     float fireRightX = pos.x + w*0.35;
    float fireY = pos.y + h*0.5 ;
    
    
    if (isLeftPressing && totalFire < fireLimit) {
      acc.add(speed, -speed * 2);
      fireLeft.startPos = new PVector(fireLeftX, fireY);
      fireLeft.fire();
    }

    if (isRightPressing && totalFire < fireLimit) {
      acc.add(-speed, -speed * 2);
      fireRight.startPos = new PVector(fireRightX, fireY);
      fireRight.fire();
    }

    acc.add(0, speed * 1.5 );
  }

  void move() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);

    float ground = ground(pos.x) - h*0.5;

    if (pos.y  >= ground && vel.y > 2) {
      isDead = true;
    }

    if (pos.y  >= ground) {
      vel.mult(0);
      pos.y = ground;
    }
  }
}
