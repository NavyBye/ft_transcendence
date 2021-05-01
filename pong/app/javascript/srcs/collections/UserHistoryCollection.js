import Backbone from 'backbone';
import model from '../models';

const UserHistoryCollection = Backbone.Collection.extend({
  model: model.UserHistoryModel,
  initialize(userId) {
    this.userId = userId;
  },
  url() {
    return `api/users/${this.userId}/histories`;
  },
});

export default UserHistoryCollection;
