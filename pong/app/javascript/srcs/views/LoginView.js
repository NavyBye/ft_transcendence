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
    const user = Radio.channel('app').request('login');
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
    $.ajax({
      type: 'POST',
      url: '/users/sign_in',
      data: this.serializeForm(),
      success(dat) {
        console.log(dat);
        console.log('success!');
      },
    });
  },
  signup() {
    $.ajax({
      type: 'POST',
      url: '/users',
      data: this.serializeForm(),
      success() {
        console.log('success!');
      },
    });
  },
});

export default LoginView;
