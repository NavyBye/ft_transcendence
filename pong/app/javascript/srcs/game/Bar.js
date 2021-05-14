import { fabric } from 'fabric';
import Entity from './Entity';
import { MAX_X, MAX_Y, INPUT_UP, INPUT_DOWN, INPUT_NATURAL } from './constant';

class Bar extends Entity {
  constructor(isLeft) {
    const bar = new fabric.Rect({
      fill: 'white',
      width: 5.0,
      height: 50.0,
    });

    if (isLeft) {
      super(100.0, MAX_Y / 2, 0.0, 0.0, bar);
    } else {
      super(MAX_X - 100, MAX_Y / 2, 0.0, 0.0, bar);
    }
    this.ay = 0.0;
    this.width = 5.0;
    this.len = 50.0;
  }

  push(input) {
    if (input === INPUT_UP) {
      this.ay = 500.0;
    } else if (input === INPUT_DOWN) {
      this.ay = -500.0;
    } else if (input === INPUT_NATURAL) {
      this.ay = 0.0;
    }
  }

  move(dt) {
    this.vy += (this.ay - this.vy * 1.5) * dt;
  }
}

export default Bar;