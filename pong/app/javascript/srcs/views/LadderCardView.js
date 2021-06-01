import $ from 'jquery/src/jquery';
import { Radio } from 'backbone';
import common from '../common';
import template from '../templates/LadderCardView.html';
import auth from '../utils/auth';

const LadderCardView = common.View.extend({
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
        game_type: 'ladder',
        addon: false,
      },
      async: false,
      success() {
        Radio.channel('route').trigger('route', 'loading');
      },
    });
  },
});

export default LadderCardView;
