import common from '../common';
import template from '../templates/DmRoomView.html';
import models from '../models';

const DmRoomView = common.View.extend({
  template,
  model: models.DmRoomModel,
  onRender() {},
});

export default DmRoomView;
