/* eslint-disable no-unused-vars */
import { Radio } from 'backbone';
import common from '../common';
import template from '../templates/GamePlayView.html';
import game from '../game';

const GuildWarTimeModalView = common.View.extend({
  el: '#game-play',
  template,
  events: {},
  onInitialize() {},
  onRender() {
    const login = Radio.channel('login').request('get');
    const moderator = 1;
    const channelId = 1;
    const canvasId = 'game-play';
    const delay = 50;
    if (login.get('id') === moderator) {
      /* I AM HOST */
      const sender = new game.GameSender(channelId);
      const receiver = new game.GameReceiver(canvasId, channelId);

      // const receiver = new game.GameReceiver(canvasId, channelId);
      setTimeout(function simulate() {
        sender.simulate(0.03);
        setTimeout(simulate, delay);
      }, delay);
    } else {
      /* I AM NON-HOST PLAYER */
      const receiver = new game.GameReceiver(canvasId, channelId);
    }

    // const game = new Game('game-play');
    // this.game = game;
    // setTimeout(function foo() {
    //   game.simulate(0.03);
    //   setTimeout(foo, 30);
    // }, 30);
  },
});

export default GuildWarTimeModalView;
