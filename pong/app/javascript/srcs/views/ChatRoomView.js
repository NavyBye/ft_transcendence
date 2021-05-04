/* eslint-disable no-new */
/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import BootstrapMenu from 'bootstrap-menu';
import Radio from 'backbone.radio';
import common from '../common';
import OkModalView from './OkModalView';
import template from '../templates/ChatRoomView.html';
import auth from '../utils/auth';
import InputPasswordModalView from './InputPasswordModalView';

const ChatRoomView = common.View.extend({
  template,
  events: {
    'click .enter-room': 'enterRoom',
  },
  onRender() {
    const chatRoomId = this.model.get('id');
    const joined = this.model.get('joined');
    const userId = Radio.channel('login').request('get').id;
    const view = this;

    if (!joined) {
      $(this.el).addClass('not-joined');
    } else if ($(this.el).hasClass('not-joined')) {
      $(this.el).removeClass('not-joined');
    }

    const joinOrExit = joined
      ? {
          name: 'Exit Room',
          onClick() {
            $.ajax({
              type: 'DELETE',
              url: `/api/chatrooms/${chatRoomId}/members/${userId}`,
              headers: auth.getTokenHeader(),
              success() {
                view.model.set('joined', false);
              },
            });
          },
          classNames: 'dropdown-item',
        }
      : {
          name: 'Join Room',
          onClick() {
            /* protected by password */
            if (view.model.get('public') === false) {
              new InputPasswordModalView({ model: view.model });
            } else {
              $.ajax({
                type: 'POST',
                url: `/api/chatrooms/${chatRoomId}/members`,
                headers: auth.getTokenHeader(),
                success() {
                  view.model.set('joined', true);
                },
              });
            }
          },
          classNames: 'dropdown-item',
        };

    this.menu = new BootstrapMenu(
      `.chatroom[chatroom-id=${this.model.get('id')}]`,
      {
        actions: [
          joinOrExit,
          {
            name: 'Destroy',
            onClick() {
              $.ajax({
                type: 'DELETE',
                url: `/api/chatrooms/${chatRoomId}`,
                headers: auth.getTokenHeader(),
              });
            },
            classNames: 'dropdown-item',
          },
        ],
      },
    );
  },
  enterRoom() {
    if (this.model.get('joined')) {
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
