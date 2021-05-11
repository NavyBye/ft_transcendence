import { Radio } from 'backbone';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/AuthView.html';
import auth from '../utils/auth';
import OkModalView from './OkModalView';

/* view for 2 factor auth (currently email auth) */

const AuthView = common.View.extend({
  el: '#content',
  template,
  events: {
    'click #auth .submit-button': 'sendAuthCode',
  },
  onRender() {
    this.addRegion('user_rank', '#user-rank');
  },
  sendAuthCode() {
    const code = $('#auth-code').val();
    $.ajax({
      type: 'POST',
      url: '/api/auth',
      headers: auth.getTokenHeader(),
      data: { code },
      success() {
        new OkModalView().show('Success', 'Successfully verified email auth!');
        Radio.channel('route').trigger('route', 'home');
      },
      error(res) {
        Radio.channel('error').request('trigger', res.responseText);
      },
    });
    $('#auth-code').val('');
  },
});

export default AuthView;
