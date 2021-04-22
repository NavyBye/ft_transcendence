import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/ChatRoomView.html';

const ChatRoomView = common.View.extend({
  template,
  // onRender() {},
  events: {
    'click .enter-room': 'enterRoom',
  },
  enterRoom() {
    const chatRoomId = this.model.get('id');
    Radio.channel('side').trigger('enter-chatroom', chatRoomId);
  },
});

export default ChatRoomView;
