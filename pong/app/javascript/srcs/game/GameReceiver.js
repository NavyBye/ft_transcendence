/* eslint-disable no-param-reassign */
/* eslint-disable class-methods-use-this */
import $ from 'jquery/src/jquery';
import { fabric } from 'fabric';
import { Radio } from 'backbone';
import Ball from './Ball';
import Bar from './Bar';
import consumer from '../../channels/consumer';

/*
 * This code was originally written in April 2020 by hyekim, written in python.
 * And translated into C, Ruby, ... and Javascript now. leave comment if you
 * port this to another language.
 */

class GameReceiver {
  constructor(canvasId, channelId, addon) {
    this.isStarted = true;
    this.winner = null;
    this.score1 = 0;
    this.score2 = 0;
    this.ball = new Ball();
    this.bars = [new Bar(true), new Bar(false)];
    const self = this;
    if (addon) {
      this.ball.fabricObj.set('fill', 'black');
      this.bars[0].fabricObj.set('fill', 'black');
      this.bars[1].fabricObj.set('fill', 'black');
    }

    /* canvas related stuffs */
    this.canvas = new fabric.Canvas(canvasId);
    this.canvas.add(this.ball.fabricObj);
    this.canvas.add(this.bars[0].fabricObj);
    this.canvas.add(this.bars[1].fabricObj);
    this.canvas.renderAll();

    this.connection = consumer.subscriptions.create(
      {
        channel: 'GameChannel',
        id: channelId,
      },
      {
        subscribed() {},
        disconnected() {},
        received(data) {
          if (!data || !data.type) return;
          if (data.type === 'end') {
            self.connection.unsubscribe();
            Radio.channel('route').trigger('route', 'home');
          } else if (data.type === 'frame') {
            self.ball.fromHash(data.ball);
            self.bars[0].fromHash(data.bars[0]);
            self.bars[1].fromHash(data.bars[1]);
            self.winner = data.winner;
            self.score1 = data.score1;
            self.score2 = data.score2;
            self.isStarted = data.isStarted;
            self.ball.update();
            self.bars[0].update();
            self.bars[1].update();
            self.simulate();
          }
        },
      },
    );

    function keyDown(event) {
      const data = { type: 'input' };
      if (event.key === 'ArrowUp') {
        data.input = 'up';
      } else if (event.key === 'ArrowDown') {
        data.input = 'down';
      } else {
        return;
      }
      self.connection.send(data);
    }

    function keyUp() {
      const data = { type: 'input', input: 'neutral' };
      self.connection.send(data);
    }

    $(document).keydown(keyDown);
    $(document).keyup(keyUp);
  }

  simulate() {
    const isDiplayNone = $('#side').css('display') === 'none';
    if (isDiplayNone) this.canvas.setWidth($('body').width());
    else this.canvas.setWidth($('body').width() - $('#side').width());
    this.canvas.setHeight($('body').height() - $('#nav').height());

    this.ball.render();
    this.bars[0].render();
    this.bars[1].render();
    this.canvas.renderAll();
    return this.checkEnd();
  }

  checkEnd() {
    if (this.score1 === 3) {
      this.winner = 1;
    } else if (this.score2 === 3) {
      this.winner = 2;
    }
  }

  isStarted() {
    return this.isStarted;
  }

  isEnd() {
    return this.winner !== null;
  }
}

export default GameReceiver;
