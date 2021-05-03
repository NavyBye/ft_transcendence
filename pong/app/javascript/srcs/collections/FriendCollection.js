import Backbone from 'backbone';
import model from '../models';

const FriendCollection = Backbone.Collection.extend({
  model: model.UserModel,
  initialize(obj) {
    if (obj && obj.userId) this.userId = obj.userId;
  },
  url() {
    return `/api/users/${this.userId}/friends`;
  },
});

export default FriendCollection;
