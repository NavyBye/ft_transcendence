/* eslint-disable no-param-reassign */
/* eslint-disable class-methods-use-this */
import { fabric } from 'fabric';
import Ball from './Ball';
import Bar from './Bar';
import { MIN_X, MAX_X, MIN_Y, MAX_Y } from './constant';

class Game {
  constructor(canvasId) {
    this.isStarted = true;
    this.winner = null;
    this.score1 = 0;
    this.score2 = 0;
    this.ball = new Ball();
    this.bars = [new Bar(true), new Bar(false)];

    /* canvas related stuffs */
    this.canvas = new fabric.Canvas(canvasId);
    this.canvas.setWidth(MAX_X);
    this.canvas.setHeight(MAX_Y);
    this.canvas.add(this.ball.fabricObj);
    this.canvas.add(this.bars[0].fabricObj);
    this.canvas.add(this.bars[1].fabricObj);
    this.canvas.renderAll();
  }

  simulate(dt) {
    this.ball.move(dt);
    this.bars[0].move(dt);
    this.bars[1].move(dt);

    this.checkWallConflictWithBall();
    this.checkBarConflictWithBall(this.bars[0]);
    this.checkBarConflictWithBall(this.bars[1]);
    this.checkWallConflictWithBar(this.bars[0]);
    this.checkWallConflictWithBar(this.bars[1]);
    this.checkGoal();

    this.canvas.renderAll();
    return this.checkEnd();
  }

  checkWallConflictWithBall() {
    if (this.ball.y + this.ball.r > MAX_Y) {
      this.ball.y -= 2 * (this.ball.y + this.ball.r - MAX_Y);
      this.ball.vy *= -1;
    } else if (this.ball.y - this.ball.r < MIN_Y) {
      this.ball.y += 2 * (this.ball.r - this.ball.y);
      this.ball.vy *= -1;
    }
  }

  checkBarConflictWithBall(bar) {
    if (
      this.ball.y >= bar.y - bar.len / 2 &&
      this.ball.y < bar.y + bar.len / 2 &&
      bar.width / 2 + this.ball.r > Math.abs(this.ball.x - bar.x)
    ) {
      if (this.ball.vx < 0) {
        this.ball.x +=
          2 * (this.ball.r - this.ball.x + (bar.x + bar.width / 2));
      } else {
        this.ball.x -=
          2 * (this.ball.x + this.ball.r - (bar.x - bar.width / 2));
      }

      this.ball.vy += bar.vy * 0.3;
      this.ball.vx *= -1;
    }
  }

  checkWallConflictWithBar(bar) {
    if (bar.y + bar.len / 2 > MAX_Y) {
      bar.y = MAX_Y - bar.len / 2;
      bar.vy = 0;
      bar.ay = 0;
    } else if (bar.y - bar.len / 2 < MIN_Y) {
      bar.y = MIN_Y + bar.len / 2;
      bar.vy = 0;
      bar.ay = 0;
    }
  }

  checkGoal() {
    if (this.ball.x < MIN_X) {
      this.ball = new Ball();
      this.score2 += 1;
      this.bars = [new Bar(true), new Bar(false)];
    } else if (this.ball.x > MAX_X) {
      this.ball = new Ball();
      this.score1 += 1;
      this.bars = [new Bar(true), new Bar(false)];
    }
  }

  checkEnd() {
    if (this.score1 === 3) {
      this.winner = 1;
    } else if (this.score2 === 3) {
      this.winner = 2;
    }
  }

  toH() {
    return {
      ball: this.ball.toH(),
      bars: [this.bars[0].toH(), this.bars[1].toH()],
      scores: [this.score1, this.score2],
      winner: this.winner,
    };
  }

  isStarted() {
    return this.isStarted;
  }

  isEnd() {
    return this.winner !== null;
  }

  pushBar(playerIdx, input) {
    this.bars[playerIdx].push(input);
  }
}

export default Game;
