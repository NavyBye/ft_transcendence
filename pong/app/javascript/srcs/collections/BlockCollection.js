import Backbone from 'backbone';
import Radio from 'backbone.radio';
import model from '../models';

const BlockCollection = Backbone.Collection.extend({
  model: model.UserModel,
  initialize() {
    const login = Radio.channel('login').request('get');
    this.userId = login.get('id');
  },
  url() {
    return `/api/users/${this.userId}/blocks`;
  },
});

export default BlockCollection;
