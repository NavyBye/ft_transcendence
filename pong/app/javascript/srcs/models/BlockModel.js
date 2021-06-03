import Backbone from 'backbone';

const BlockModel = Backbone.Model.extend({
  defaults: {
    user_id: 0,
    blocked_user_id: 0,
  },
});

export default BlockModel;
