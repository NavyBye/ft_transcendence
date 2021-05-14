import { fabric } from 'fabric';
import { MAX_X, MAX_Y } from './constant';
import Entity from './Entity';

function randomRange(min, max) {
  const val = Math.floor(Math.random() * (max - min + 1)) + min;
  return val;
}

class Ball extends Entity {
  constructor() {
    const randVy = randomRange(-50, 50);
    const randSign = randomRange(-1, 1);
    const circle = new fabric.Circle({
      radius: 10.0,
      fill: 'red',
      left: MAX_X / 2,
      top: MAX_Y / 2,
    });
    super(
      MAX_X / 2,
      MAX_Y / 2,
      randSign * Math.sqrt(400 ** 2 - randVy ** 2),
      randVy,
      circle,
    );
    this.r = 10.0;
  }
}

export default Ball;
