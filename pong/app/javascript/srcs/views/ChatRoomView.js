/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import BootstrapMenu from 'bootstrap-menu';
import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/ChatRoomView.html';

const ChatRoomView = common.View.extend({
  template,
  // onRender() {},
  events: {
    'click .enter-room': 'enterRoom',
  },
  onRender() {
    const id = this.model.get('id');
    this.menu = new BootstrapMenu(`.chatroom[room-id=${id}]`, {
      actions: [
        {
          name: 'Destroy',
          onClick() {
            $.ajax({
              type: 'DELETE',
              url: `/api/chatrooms/${id}`,
            });
          },
          classNames: 'dropdown-item',
        },
      ],
    });
  },
  enterRoom() {
    const chatRoomId = this.model.get('id');
    Radio.channel('side').trigger('enter-chatroom', chatRoomId);
  },
});

export default ChatRoomView;
