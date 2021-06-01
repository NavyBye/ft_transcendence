import Radio from 'backbone.radio';
import $ from 'jquery/src/jquery';
import common from '../common';
import auth from '../utils/auth';
import template from '../templates/ChallengeView.html';

const ChallengeView = common.View.extend({
  template,
  events: {
    'click h4': 'ladderChallenge',
  },
  onInitialize() {},
  ladderChallenge() {
    const self = this;
    $.ajax({
      type: 'POST',
      url: '/api/games',
      headers: auth.getTokenHeader(),
      data: {
        game_type: 'ladder_tournament',
        addon: false,
        target_id: self.model.get('id'),
      },
      async: false,
      success() {
        $('#challenge-modal').modal('hide');
        Radio.channel('route').trigger('route', 'loading');
      },
      error(res) {
        $('#challenge-modal').modal('hide');
        Radio.channel('error').request('trigger', res.responseText);
      },
    });
  },
});

export default ChallengeView;
