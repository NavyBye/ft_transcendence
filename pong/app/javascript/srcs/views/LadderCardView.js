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
        type: 'ladder',
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

export default LadderCardView;
