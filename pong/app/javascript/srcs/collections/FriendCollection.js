import Backbone from 'backbone';
import model from '../models';

const FriendCollection = Backbone.Collection.extend({
  model: model.FriendModel,
  initialize(userId) {
    this.userId = userId;
  },
  url() {
    return `/api/users/${this.userId}/friends`;
  },
});

export default FriendCollection;
