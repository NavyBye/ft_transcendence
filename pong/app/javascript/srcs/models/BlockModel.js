import Backbone from 'backbone';

const BlockModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    user_id: 0,
    block_user_id: 0,
  },
});

export default BlockModel;
