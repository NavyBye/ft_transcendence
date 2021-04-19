import common from '../common';
import recvTemplate from '../templates/RecvChatView.html';
import sendTemplate from '../templates/SendChatView.html';
import models from '../models';

const ChatView = common.View.extend({
  recvTemplate,
  sendTemplate,
  model: models.ChatModel,
  onRender() {},
});

export default ChatView;
