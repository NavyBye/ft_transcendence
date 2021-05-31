import $ from 'jquery/src/jquery';
import common from '../common';
import auth from '../utils/auth';

const RequestPongMatchModalView = common.View.extend({
  el: '#request-pong-match-modal-view',
  events: {
    'click .accept-button': 'accept',
    'click .refuse-button': 'refuse',
  },
  onInitialize(obj) {
    this.game = obj.game;
    this.user = obj.user;
    $(this.el).modal('show');
  },
  accept() {
    const self = this;
    $.ajax({
      type: 'POST',
      url: '/api/games',
      headers: auth.getTokenHeader(),
      data: {
        game_type: self.game.game_type,
        addon: false,
      },
    });
    $(this.el).modal('hide');
  },
  refuse() {
    $.ajax({
      type: 'DELETE',
      url: '/api/games/cancel',
      headers: auth.getTokenHeader(),
    });
    $(this.el).modal('hide');
  },
});

export default RequestPongMatchModalView;
