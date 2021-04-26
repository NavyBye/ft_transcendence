/* eslint-disable prefer-destructuring */
import Radio from 'backbone.radio';
import BootstrapMenu from 'bootstrap-menu';
import $ from 'jquery/src/jquery';
import common from '../common';
import recvTemplate from '../templates/RecvChatView.html';
import sendTemplate from '../templates/SendChatView.html';

const ChatView = common.View.extend({
  recvTemplate,
  sendTemplate,
  onInitialize() {
    const me = Radio.channel('app').request('login');
    if (this.model.get('user').id === me.id) {
      this.template = sendTemplate;
    } else {
      this.template = recvTemplate;
      const userId = this.model.get('user').id;
      this.menu = new BootstrapMenu(`.recv-chat[user-id=${userId}]`, {
        actions: [
          {
            /* TODO: add should be in profile, it's for testing */
            name: 'add friend',
            onClick() {
              const login = Radio.channel('app').request('login');
              $.ajax({
                type: 'POST',
                url: `/api/users/${login.id}/friends`,
                data: { follow_id: userId },
              });
            },
            classNames: 'dropdown-item',
          },
        ],
      });
    }
  },
});

export default ChatView;
