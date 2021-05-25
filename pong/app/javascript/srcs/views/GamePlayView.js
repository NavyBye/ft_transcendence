/* eslint-disable no-unused-vars */
import { Radio } from 'backbone';
import common from '../common';
import template from '../templates/GamePlayView.html';
import game from '../game';

const GuildWarTimeModalView = common.View.extend({
  el: '#game-play',
  template,
  events: {},
  onInitialize(obj) {
    this.isHost = obj.isHost;
    this.channelId = obj.channelId;
  },
  onRender() {
    const login = Radio.channel('login').request('get');
    const moderator = 1;
    const canvasId = 'game-play';
    const delay = 50;
    if (this.isHost) {
      const sender = new game.GameSender(this.channelId);
      const receiver = new game.GameReceiver(canvasId, this.channelId);

      setTimeout(function simulate() {
        sender.simulate(0.03);
        setTimeout(simulate, delay);
      }, delay);
    } else {
      const receiver = new game.GameReceiver(canvasId, this.channelId);
    }
  },
});

export default GuildWarTimeModalView;
