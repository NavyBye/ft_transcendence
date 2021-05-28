/* eslint-disable no-new */
import common from '../common';
import template from '../templates/AdminGuildView.html';
import AdminGuildModalView from './AdminGuildModalView';

const AdminGuildView = common.View.extend({
  template,
  tagName: 'tr',
  className: 'row',
  events: {
    'click td': 'showGuildInfoModal',
  },
  onInitialize() {},
  onRender() {},
  showGuildInfoModal() {
    new AdminGuildModalView({ model: this.model });
  },
});

export default AdminGuildView;
