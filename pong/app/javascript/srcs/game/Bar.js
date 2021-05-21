import $ from 'jquery/src/jquery';
import { fabric } from 'fabric';
import Entity from './Entity';
import { MAX_X, MAX_Y, BAR_HEIGHT, BAR_WIDTH } from './constant';

class Bar extends Entity {
  constructor(isLeft) {
    const bar = new fabric.Rect({
      fill: 'white',
      width: (BAR_WIDTH * $('#game-play').width()) / MAX_X,
      height: (BAR_HEIGHT * $('#game-play').height()) / MAX_Y,
    });

    if (isLeft) {
      super(100.0, MAX_Y / 2, 0.0, 0.0, bar);
    } else {
      super(MAX_X - 100, MAX_Y / 2, 0.0, 0.0, bar);
    }
    this.ay = 0.0;
  }

  push(input) {
    if (input === 'up') {
      this.ay = 500.0;
    } else if (input === 'down') {
      this.ay = -500.0;
    } else if (input === 'neutral') {
      this.ay = 0.0;
    }
  }

  /* used in GameSender */
  move(dt) {
    this.vy += (this.ay - this.vy * 1.5) * dt;
    this.y += dt * this.vy;
  }

  /* used in GameReceiver */
  update() {
    const width = (BAR_WIDTH * $('#game-play').width()) / MAX_X;
    const height = (BAR_HEIGHT * $('#game-play').height()) / MAX_Y;
    this.fabricObj.set('width', width);
    this.fabricObj.set('height', height);
    this.render();
  }
}

export default Bar;
