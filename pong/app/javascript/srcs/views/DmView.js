/* eslint-disable no-new */
/* eslint-disable prefer-destructuring */
import Radio from 'backbone.radio';
import common from '../common';
import recvTemplate from '../templates/RecvChatView.html';
import sendTemplate from '../templates/SendChatView.html';
import UserProfileModalView from './UserProfileModalView';

const DmView = common.View.extend({
  recvTemplate,
  sendTemplate,
  events: {
    'click img': 'showProfile',
  },
  onInitialize() {
    const me = Radio.channel('login').request('get');
    const userId = this.model.get('user').id;
    if (userId === me.get('id')) {
      this.template = sendTemplate;
    } else {
      this.template = recvTemplate;
    }
  },
  showProfile() {
    new UserProfileModalView(this.model.get('user').id);
  },
});

export default DmView;
