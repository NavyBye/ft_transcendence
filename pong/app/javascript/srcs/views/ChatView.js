/* eslint-disable no-new */
/* eslint-disable prefer-destructuring */
import Radio from 'backbone.radio';
import BootstrapMenu from 'bootstrap-menu';
import $ from 'jquery/src/jquery';
import common from '../common';
import recvTemplate from '../templates/RecvChatView.html';
import sendTemplate from '../templates/SendChatView.html';
import servTemplate from '../templates/ServChatView.html';
import UserProfileModalView from './UserProfileModalView';
import auth from '../utils/auth';
import InputBanDurationModalView from './InputBanDurationModalView';
import InputMuteDurationModalView from './InputMuteDurationModalView';

const ChatView = common.View.extend({
  recvTemplate,
  sendTemplate,
  servTemplate,
  events: {
    'click img': 'showProfile',
  },
  onInitialize() {
    if (this.model.get('type') === 'notification') {
      this.template = servTemplate;
    } else if (this.model.get('type') === 'message') {
      const me = Radio.channel('login').request('get');
      const userId = this.model.get('user').id;

      const isBlocked = Radio.channel('blacklist').request(
        'isBlocked',
        this.model.get('user').id,
      );

      /* no template if blocked */
      if (isBlocked) {
        return;
      }

      if (userId === me.get('id')) {
        this.template = sendTemplate;
      } else {
        this.template = recvTemplate;
        this.menu = new BootstrapMenu(
          `.recv-chat[chat-id=${this.model.get('id')}]`,
          {
            actions: [
              {
                name: 'ban',
                onClick() {
                  new InputBanDurationModalView(userId);
                },
                classNames: 'dropdown-item',
              },
              {
                name: 'mute',
                onClick() {
                  new InputMuteDurationModalView(userId);
                },
                classNames: 'dropdown-item',
              },
              {
                name: 'free',
                onClick() {
                  const chatRoomId = Radio.channel('chat-collection').request(
                    'getId',
                  );
                  $.ajax({
                    type: 'POST',
                    url: `/api/chatrooms/${chatRoomId}/members/${userId}/free`,
                    headers: auth.getTokenHeader(),
                  });
                },
                classNames: 'dropdown-item',
              },
              {
                name: 'give admin',
                onClick() {
                  const chatRoomId = Radio.channel('chat-collection').request(
                    'getId',
                  );
                  $.ajax({
                    type: 'PUT',
                    url: `/api/chatrooms/${chatRoomId}/members/${userId}`,
                    headers: auth.getTokenHeader(),
                    data: { role: 'admin' },
                  });
                },
                classNames: 'dropdown-item',
              },
              {
                name: 'take admin',
                onClick() {
                  const chatRoomId = Radio.channel('chat-collection').request(
                    'getId',
                  );
                  $.ajax({
                    type: 'PUT',
                    url: `/api/chatrooms/${chatRoomId}/members/${userId}`,
                    headers: auth.getTokenHeader(),
                    data: { role: 'user' },
                  });
                },
                classNames: 'dropdown-item',
              },
            ],
          },
        );
      }
    }
  },
  showProfile() {
    new UserProfileModalView(this.model.get('user').id);
  },
});

export default ChatView;
