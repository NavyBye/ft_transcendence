/* eslint-disable no-unused-vars */
import { Radio } from 'backbone';
import _ from 'underscore';
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
    this.addon = obj.addon;
    if (!this.addon) this.addon = false;
    this.gameObjects = [];
  },
  onRender() {
    const login = Radio.channel('login').request('get');
    const moderator = 1;
    const canvasId = 'game-play';
    const delay = 40;
    const self = this;
    if (this.isHost) {
      const sender = new game.GameSender(this.channelId);
      this.sender = sender;
      const receiver = new game.GameReceiver(
        canvasId,
        this.channelId,
        this.addon,
      );
      self.gameObjects.push(receiver);
      self.gameObjects.push(sender);
      setTimeout(function simulate() {
        sender.simulate(1 / delay);
        console.log(`sender: isEnd: ${sender.isEnd}`);
        if (sender.isEnd) {
          sender.endGame();
        } else {
          setTimeout(simulate, delay);
        }
      }, delay);
    } else {
      const receiver = new game.GameReceiver(
        canvasId,
        this.channelId,
        this.addon,
      );
      self.gameObjects.push(receiver);
    }
  },
  onDestroy() {
    /* unsubscribe if user moves to another route */
    _.forEach(this.gameObjects, function disconnect(obj) {
      obj.connection.unsubscribe();
    });
    if (this.sender) {
      this.sender.isEnd = true;
    }
  },
});

export default GuildWarTimeModalView;
