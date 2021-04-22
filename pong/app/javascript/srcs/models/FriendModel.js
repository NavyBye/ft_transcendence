import Backbone from 'backbone';

const FriendModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    nickname: '',
    status: 1,
  },
});

export default FriendModel;
