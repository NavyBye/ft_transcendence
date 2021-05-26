/* eslint-disable no-param-reassign */
/* eslint-disable class-methods-use-this */
import { Radio } from 'backbone';
import Ball from './Ball';
import Bar from './Bar';
import consumer from '../../channels/consumer';
import {
  MIN_X,
  MAX_X,
  MIN_Y,
  MAX_Y,
  BAR_WIDTH,
  BAR_HEIGHT,
  BALL_RADIUS,
} from './constant';

/*
 * This code was originally written in April 2020 by hyekim, written in python.
 * And translated into C, Ruby, ... and Javascript now. leave comment if you
 * port this to another language.
 */

/* This is for Moderator of the game */

class GameSender {
  constructor(channelId) {
    this.isStarted = true;
    this.winner = null;
    this.score1 = 0;
    this.score2 = 0;
    this.ball = new Ball();
    this.bars = [new Bar(true), new Bar(false)];
    const self = this;
    this.connection = consumer.subscriptions.create(
      {
        channel: 'GameChannel',
        id: channelId,
      },
      {
        subscribed() {},
        disconnected() {},
        received(data) {
          if (!data) return;
          if (data.type === 'end') {
            console.log('hello, this is end message!');
            self.connection.unsubscribe();
            Radio.channel('route').trigger('route', 'home');
          } else if (data.type === 'input') {
            /* TODO: server doesn't send it */
            self.pushBar(data.is_host ? 0 : 1, data.input);
          }
        },
      },
    );
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

    this.connection.send(this.toHash());
    return this.checkEnd();
  }

  checkWallConflictWithBall() {
    if (this.ball.y + BALL_RADIUS > MAX_Y) {
      this.ball.y -= 2 * (this.ball.y + BALL_RADIUS - MAX_Y);
      this.ball.vy *= -1;
    } else if (this.ball.y - BALL_RADIUS < MIN_Y) {
      this.ball.y += 2 * (BALL_RADIUS - this.ball.y);
      this.ball.vy *= -1;
    }
  }

  checkBarConflictWithBall(bar) {
    if (
      /* below two lines mean: is y of ball between bar's start and end?  */
      this.ball.y + 2 * BALL_RADIUS >= bar.y &&
      this.ball.y <= bar.y + BAR_HEIGHT &&
      /* is ball's x is greater than bar's x? (conflict with bar) */
      BAR_WIDTH + BALL_RADIUS > Math.abs(this.ball.x - bar.x) /* */
    ) {
      if (this.ball.vx < 0) {
        this.ball.x +=
          2 * (BALL_RADIUS - this.ball.x + (bar.x + BAR_WIDTH / 2));
      } else {
        this.ball.x -=
          2 * (this.ball.x + BALL_RADIUS - (bar.x - BAR_WIDTH / 2));
      }

      this.ball.vy += bar.vy * 0.3;
      this.ball.vx *= -1;
    }
  }

  checkWallConflictWithBar(bar) {
    if (bar.y + BAR_HEIGHT > MAX_Y) {
      /* lower side wall */
      bar.y = MAX_Y - BAR_HEIGHT;
      bar.vy = 0;
      bar.ay = 0;
    } else if (bar.y < MIN_Y) {
      /* upper side wall */
      bar.y = MIN_Y;
      bar.vy = 0;
      bar.ay = 0;
    }
  }

  checkGoal() {
    if (this.ball.x < MIN_X) {
      this.score2 += 1;
    } else if (this.ball.x > MAX_X) {
      this.score1 += 1;
    } else {
      return;
    }

    this.ball.reset();
    this.bars[0].reset();
    this.bars[1].reset();
  }

  checkEnd() {
    let ret = true;
    if (this.score1 === 3) {
      this.winner = 1;
    } else if (this.score2 === 3) {
      this.winner = 2;
    } else {
      ret = false;
    }
    return ret;
  }

  endGame() {
    this.connection.send({ type: 'end', scores: [this.score1, this.score2] });
  }

  toHash() {
    return {
      type: 'frame',
      ball: this.ball.toHash(),
      bars: [this.bars[0].toHash(), this.bars[1].toHash()],
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

export default GameSender;
