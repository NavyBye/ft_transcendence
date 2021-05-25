import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/LadderTournamentCardView.html';
import auth from '../utils/auth';

const LadderTournamentCardView = common.View.extend({
  template,
  events: {},
  onInitialize() {},
  onRender() {},
  click() {
    $.ajax({
      type: 'POST',
      url: '/api/games',
      headers: auth.getTokenHeader(),
      data: {
        game_type: 'ladder_tournament',
        addon: false,
      },
      async: false,
      success() {
        Radio.channel('route').trigger('route', 'loading');
      },
      error(res) {
        Radio.channel('error').request('trigger', res.responseText);
      },
    });
  },
});

export default LadderTournamentCardView;
