import $ from 'jquery/src/jquery';
import { MAX_X, MAX_Y } from './constant';

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
    /* convert x, y to fit current canvas */
    const selector = '#game-play';
    const x = ($(selector).width() * this.x) / MAX_X;
    const y = ($(selector).height() * this.y) / MAX_Y;

    this.fabricObj.set('left', x);
    this.fabricObj.set('top', y);
  }

  toHash() {
    return {
      x: this.x,
      y: this.y,
    };
  }

  fromHash(hash) {
    this.x = hash.x;
    this.y = hash.y;
  }

  /* TODO: move should be here */
}

export default Entity;
