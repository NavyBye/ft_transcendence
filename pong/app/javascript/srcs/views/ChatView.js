import common from '../common';
import recvTemplate from '../templates/RecvChatView.html';
import sendTemplate from '../templates/SendChatView.html';

const ChatView = common.View.extend({
  recvTemplate,
  sendTemplate,
  onRender() {},
});

export default ChatView;
