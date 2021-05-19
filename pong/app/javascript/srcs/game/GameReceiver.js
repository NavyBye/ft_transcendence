/* eslint-disable no-param-reassign */
/* eslint-disable class-methods-use-this */
import $ from 'jquery/src/jquery';
import { fabric } from 'fabric';
import Ball from './Ball';
import Bar from './Bar';
import consumer from '../../channels/consumer';

/*
 * This code was originally written in April 2020 by hyekim, written in python.
 * And translated into C, Ruby, ... and Javascript now. leave comment if you
 * port this to another language.
 */

class GameReceiver {
  constructor(canvasId, channelId) {
    this.isStarted = true;
    this.winner = null;
    this.score1 = 0;
    this.score2 = 0;
    this.ball = new Ball();
    this.bars = [new Bar(true), new Bar(false)];
    const self = this;
    this.connection = consumer.subscriptions.create({
      channel: 'GameChannel',
      id: channelId,
      subscribed() {},
      disconnected() {},
      received(data) {
        if (!data) return;
        self.ball.fromHash(data.ball);
        self.bars[0].fromHash(data.bars[0]);
        self.bars[1].fromHash(data.bars[1]);
      },
    });

    /* canvas related stuffs */
    this.canvas = new fabric.Canvas(canvasId);
    this.canvas.add(this.ball.fabricObj);
    this.canvas.add(this.bars[0].fabricObj);
    this.canvas.add(this.bars[1].fabricObj);
    this.canvas.renderAll();
  }

  simulate() {
    const isDiplayNone = $('#side').css('display') === 'none';
    if (isDiplayNone) this.canvas.setWidth($('body').width());
    else this.canvas.setWidth($('body').width() - $('#side').width());
    this.canvas.setHeight($('body').height() - $('#nav').height());
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
