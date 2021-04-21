import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/LoginView.html';

const LoginView = common.View.extend({
  template,
  onRender() {
    const user = Radio.channel('app').request('login');
    if (user) {
      Radio.channel('route').trigger('route', 'home');
    }
  },
});

export default LoginView;
