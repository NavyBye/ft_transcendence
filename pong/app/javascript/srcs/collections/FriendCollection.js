import Radio from 'backbone.radio';
import Backbone from 'backbone';
import model from '../models';

const FriendCollection = Backbone.Collection.extend({
  model: model.UserModel,
  initialize() {
    const login = Radio.channel('login').request('get');
    this.userId = login.get('id');
  },
  url() {
    return `/api/users/${this.userId}/friends`;
  },
});

export default FriendCollection;
