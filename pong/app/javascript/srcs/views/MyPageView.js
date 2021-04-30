import common from '../common';
import template from '../templates/MyPageView.html';

const LoginView = common.View.extend({
  el: '#my-page',
  template,
  events: {},
  onRender() {},
});

export default LoginView;
