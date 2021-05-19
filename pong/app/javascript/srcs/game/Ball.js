import $ from 'jquery/src/jquery';
import { fabric } from 'fabric';
import { MAX_X, MAX_Y, BALL_RADIUS } from './constant';
import Entity from './Entity';

function randomRange(min, max) {
  const val = Math.floor(Math.random() * (max - min + 1)) + min;
  return val;
}

class Ball extends Entity {
  constructor() {
    const randVy = randomRange(-50, 50);
    const randSign = randomRange(1, 2) === 1 ? 1 : -1;

    const circle = new fabric.Ellipse({
      fill: 'red',
      left: MAX_X / 2,
      top: MAX_Y / 2,
      rx: (BALL_RADIUS * $('#game-play').width()) / MAX_X,
      ry: (BALL_RADIUS * $('#game-play').height()) / MAX_Y,
    });
    super(
      MAX_X / 2,
      MAX_Y / 2,
      randSign * Math.sqrt(400 ** 2 - randVy ** 2),
      randVy,
      circle,
    );
  }

  move(dt) {
    this.x += this.vx * dt;
    this.y += this.vy * dt;
    const rx = (BALL_RADIUS * $('#game-play').width()) / MAX_X;
    const ry = (BALL_RADIUS * $('#game-play').height()) / MAX_Y;
    this.fabricObj.set('rx', rx);
    this.fabricObj.set('ry', ry);
    this.render();
  }
}

export default Ball;
