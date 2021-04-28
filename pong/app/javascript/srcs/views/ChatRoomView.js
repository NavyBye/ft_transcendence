/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import BootstrapMenu from 'bootstrap-menu';
import Radio from 'backbone.radio';
import common from '../common';
import OkModalView from './OkModalView';
import template from '../templates/ChatRoomView.html';

const ChatRoomView = common.View.extend({
  template,
  events: {
    'click .enter-room': 'enterRoom',
  },
  onRender() {
    const view = this;
    const chatRoomId = this.model.get('id');
    const isJoined = Radio.channel('chatroom').request('isJoined', chatRoomId);
    const userId = Radio.channel('app').request('login').id;
    this.isJoined = isJoined;
    if (!this.isJoined) {
      $(this.el).addClass('not-joined');
    }
    const joinOrExit = isJoined
      ? {
          name: 'Exit Room',
          onClick() {
            $.ajax({
              type: 'DELETE',
              url: `/api/chatrooms/${chatRoomId}/members/${userId}`,
              success() {
                view.render();
              },
            });
          },
          classNames: 'dropdown-item',
        }
      : {
          name: 'Join Room',
          onClick() {
            $.ajax({
              type: 'POST',
              url: `/api/chatrooms/${chatRoomId}/members`,
              success() {
                view.render();
              },
            });
          },
          classNames: 'dropdown-item',
        };

    this.menu = new BootstrapMenu(`.chatroom[room-id=${chatRoomId}]`, {
      actions: [
        joinOrExit,
        {
          name: 'Destroy',
          onClick() {
            $.ajax({
              type: 'DELETE',
              url: `/api/chatrooms/${chatRoomId}`,
            });
          },
          classNames: 'dropdown-item',
        },
      ],
    });
  },
  enterRoom() {
    if (this.isJoined) {
      const chatRoomId = this.model.get('id');
      Radio.channel('side').trigger('enter-chatroom', chatRoomId);
    } else {
      new OkModalView().show(
        'You are not in the room',
        'right click chatroom and click "Join Room"',
      );
    }
  },
});

export default ChatRoomView;
