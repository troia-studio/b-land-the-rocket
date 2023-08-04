class FireGas {
  PVector startPos;
  float dist = 70;
  float fireLifeMs = 500;

  ArrayList<GasParticle> particles = new ArrayList<GasParticle>();

  FireGas(PVector startPos) {
    this.startPos = startPos;
  }

  void fire() {
    for (int i = 0; i < 1; i++) {
      float a = random(PI * 1.33, PI * 1.67);
      float endX = startPos.x - cos(a) * dist;
      float endY = startPos.y - sin(a) * dist;

      float deltaMs = 1000.0 / frameRate;
      PVector goneVector = new PVector(endX- startPos.x, endY - startPos.y);
      goneVector.mult(deltaMs / fireLifeMs);

      GasParticle newGP = new GasParticle(startPos.copy(), goneVector, dist);
      particles.add(newGP);
    }
  }

  void cease() {
    for (int i = 0; i < particles.size(); i++) {
      if (particles.get(i).life >= 1) {
        particles.remove(i);
      }
    }
  }

  void show() {
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).move();
      particles.get(i).show();
    }
  }
}

class GasParticle {
  PVector pos;
  PVector vel;
  int size = 40;
  float life = 0;
  float distance;
  color c;

  GasParticle(PVector pos, PVector vel, float distance) {
    this.pos= pos;
    this.vel=vel;
    this.distance = distance;
    c = color(random(150, 180));
  }

  void move() {
    pos.add(vel);
    life += vel.mag() / distance;
    println(pos.y);
  }

  void show() {
    //fill(150, (1.0 - life) * 200);
    
    fill(c);
    float d = (0.2 + 0.8 * sqrt(life)) * size;
    circle(pos.x, pos.y, d);
  }
}
