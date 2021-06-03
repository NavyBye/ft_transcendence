import common from '../common';
import template from '../templates/UserHistoryView.html';

const UserHistoryView = common.View.extend({
  template,
  tagName: 'tr',
  onRender() {},
});

export default UserHistoryView;
