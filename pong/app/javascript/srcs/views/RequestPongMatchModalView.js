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

    /* If modal is closed without click button, refuse the request */
    const self = this;
    this.buttonClicked = false;
    $(this.el).on('hide.bs.modal', function destroy() {
      self.destroy();
      if (!self.buttonClicked) {
        $.ajax({
          type: 'DELETE',
          url: '/api/games/cancel',
          headers: auth.getTokenHeader(),
        });
      }
    });
  },
  accept() {
    const self = this;
    this.buttonClicked = true;
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
    this.buttonClicked = true;
    $.ajax({
      type: 'DELETE',
      url: '/api/games/cancel',
      headers: auth.getTokenHeader(),
    });
    $(this.el).modal('hide');
  },
});

export default RequestPongMatchModalView;
