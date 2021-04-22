import Radio from 'backbone.radio';
import common from '../common';
import recvTemplate from '../templates/RecvChatView.html';
import sendTemplate from '../templates/SendChatView.html';

const ChatView = common.View.extend({
  recvTemplate,
  sendTemplate,
  onInitialize() {
    const me = Radio.channel('app').request('login');
    if (this.model.get('user_id') === me.id) {
      this.template = sendTemplate;
    } else {
      this.template = recvTemplate;
    }
  },
  onRender() {},
});

export default ChatView;
