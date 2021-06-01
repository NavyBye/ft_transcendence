import { Radio } from 'backbone';
import $ from 'jquery/src/jquery';
import auth from '../utils/auth';
import common from '../common';
import template from '../templates/GuildWarCardView.html';

const GuildWarCardView = common.View.extend({
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
        game_type: 'war',
      },
      async: false,
      success() {
        Radio.channel('route').trigger('route', 'loading');
      },
    });
  },
});

export default GuildWarCardView;
