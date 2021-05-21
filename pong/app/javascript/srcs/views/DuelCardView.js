import { Radio } from 'backbone';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/DuelCardView.html';
import auth from '../utils/auth';

const DuelCardView = common.View.extend({
  template,
  onInitialize() {},
  onRender() {},
  click() {
    $.ajax({
      type: 'POST',
      url: '/api/games',
      headers: auth.getTokenHeader(),
      data: {
        game_type: 'duel',
        addon: false,
      },
      success() {
        Radio.channel('route').trigger('route', 'loading');
      },
      error(res) {
        Radio.channel('error').request('trigger', res.responseText);
      },
    });
  },
});

export default DuelCardView;
