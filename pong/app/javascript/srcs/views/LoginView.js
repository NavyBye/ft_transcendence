import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/LoginView.html';
import auth from '../utils/auth';

const LoginView = common.View.extend({
  el: '#root',
  template,
  events: {
    'click #login-button': 'login',
    'click #signup-button': 'signup',
  },
  onRender() {
    const user = Radio.channel('login').request('get');
    if (user) {
      Radio.channel('route').trigger('route', 'home');
    }
  },
  serializeForm() {
    const data = {};
    data[auth.getTokenKey()] = auth.getTokenValue();
    data['user[email]'] = $('#user_email').val();
    data['user[password]'] = $('#user_password').val();
    return data;
  },
  login() {
    const rootView = Radio.channel('app').request('rootView');
    $.ajax({
      type: 'POST',
      url: '/users/sign_in',
      headers: auth.getTokenHeader(),
      data: this.serializeForm(),
      success(res) {
        rootView.getRegion('content').getView().destroy();
        rootView.getRegion('content').view = null;
        $('meta[name="csrf-param"]').attr('content', res.csrf_param);
        $('meta[name="csrf-token"]').attr('content', res.csrf_token);
        Radio.channel('login').request('fetch');
        Radio.channel('route').trigger('route', 'home');
      },
    });
  },
  signup() {
    $.ajax({
      type: 'POST',
      url: '/users',
      headers: auth.getTokenHeader(),
      data: this.serializeForm(),
      success(res) {
        $('meta[name="csrf-param"]').attr('content', res.csrf_param);
        $('meta[name="csrf-token"]').attr('content', res.csrf_token);
        Radio.channel('login').request('fetch');
        Radio.channel('route').trigger('route', 'home');
      },
    });
  },
});

export default LoginView;
