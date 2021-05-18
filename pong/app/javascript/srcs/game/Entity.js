function randomRange(min, max) {
  const val = Math.floor(Math.random() * (max - min + 1)) + min;
  return val;
}

class Entity {
  constructor(x, y, vx, vy, fabricObj) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.originalX = x;
    this.originalY = y;
    this.fabricObj = fabricObj;
    this.render();
  }

  reset() {
    this.x = this.originalX;
    this.y = this.originalY;
    const randVy = randomRange(-50, 50);
    const randSign = randomRange(1, 2) === 1 ? 1 : -1;
    this.vx = randSign * Math.sqrt(400 ** 2 - randVy ** 2);
    this.vy = randVy;
  }

  render() {
    this.fabricObj.set('left', this.x);
    this.fabricObj.set('top', this.y);
  }

  move(dt) {
    this.x += this.vx * dt;
    this.y += this.vy * dt;
    this.render();
  }

  toH() {
    return {
      x: this.x,
      y: this.y,
      vx: this.vx,
      vy: this.vy,
    };
  }
}

export default Entity;
