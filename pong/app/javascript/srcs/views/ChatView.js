/* eslint-disable no-new */
/* eslint-disable prefer-destructuring */
import Radio from 'backbone.radio';
import BootstrapMenu from 'bootstrap-menu';
import $ from 'jquery/src/jquery';
import common from '../common';
import recvTemplate from '../templates/RecvChatView.html';
import sendTemplate from '../templates/SendChatView.html';
import UserProfileModalView from './UserProfileModalView';
import auth from '../utils/auth';

const ChatView = common.View.extend({
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
      this.menu = new BootstrapMenu(
        `.recv-chat[chat-id=${this.model.get('id')}]`,
        {
          actions: [
            {
              /* TODO: add should be in profile, it's for testing */
              name: 'add friend',
              onClick() {
                const login = Radio.channel('login').request('get');
                $.ajax({
                  type: 'POST',
                  url: `/api/users/${login.get('id')}/friends`,
                  headers: auth.getTokenHeader(),
                  data: { follow_id: userId },
                });
              },
              classNames: 'dropdown-item',
            },
          ],
        },
      );
    }
  },
  showProfile() {
    new UserProfileModalView(this.model.get('user').id);
  },
});

export default ChatView;
