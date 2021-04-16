import common from '../common';
import template from '../templates/ChatRoomView.html';
import models from '../models';

const ChatRoomView = common.View.extend({
  template,
  model: models.ChatRoomModel,
  onRender() {},
});

export default ChatRoomView;
