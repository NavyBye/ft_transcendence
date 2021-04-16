import common from '../common';
import template from '../templates/FriendView.html';
import models from '../models';

const FriendView = common.View.extend({
  template,
  model: models.FriendModel,
  onRender() {},
});

export default FriendView;
