import common from '../common';
import recvTemplate from '../templates/RecvChatView.html';
import sendTemplate from '../templates/SendChatView.html';
import models from '../models';

const DmView = common.View.extend({
  recvTemplate,
  sendTemplate,
  model: models.DmModel,
  onRender() {},
});

export default DmView;
