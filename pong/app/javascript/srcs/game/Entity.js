class Entity {
  constructor(x, y, vx, vy, fabricObj) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.fabricObj = fabricObj;
    this.render();
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
