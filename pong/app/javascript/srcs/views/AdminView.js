import common from '../common';
import template from '../templates/AdminView.html';

const AdminView = common.View.extend({
  el: '#content',
  template,
  events: {
    'click #admin .submit-button': 'sendAuthCode',
  },
  onRender() {},
});

export default AdminView;
