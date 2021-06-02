/* eslint-disable no-unused-vars */
import $ from 'jquery/src/jquery';
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
    this.left = obj.left;
    this.right = obj.right;
    this.is_host = obj.is_host;
    this.game_id = obj.game_id;
    this.addon = obj.addon;
    this.gameObjects = [];
  },
  onRender() {
    /* draw player info */
    $('#player1-image').attr('src', this.left.image.url);
    $('#player1-name').text(this.left.nickname);
    $('#player2-image').attr('src', this.right.image.url);
    $('#player2-name').text(this.right.nickname);

    const login = Radio.channel('login').request('get');
    const moderator = 1;
    const canvasId = 'game-play';
    const delay = 40;
    const self = this;
    if (this.is_host) {
      const sender = new game.GameSender(this.game_id);
      this.sender = sender;
      const receiver = new game.GameReceiver(
        canvasId,
        this.game_id,
        this.addon,
        true,
      );
      self.disconnected = false;
      self.gameObjects.push(receiver);
      self.gameObjects.push(sender);
      setTimeout(function simulate() {
        sender.simulate(1 / delay);
        if (self.disconnected) return;

        if (sender.isEnd) {
          sender.endGame();
        } else {
          setTimeout(simulate, delay);
        }
      }, delay);
    } else {
      const receiver = new game.GameReceiver(
        canvasId,
        this.game_id,
        this.addon,
        false,
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
      this.disconnected = true;
      this.sender.isEnd = true;
    }
  },
});

export default GuildWarTimeModalView;
