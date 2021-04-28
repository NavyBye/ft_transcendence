import Backbone from 'backbone';
import Radio from 'backbone.radio';
import model from '../models';

const BlockCollection = Backbone.Collection.extend({
  model: model.BlockModel,
  initialize() {
    const login = Radio.channel('app').request('login');
    this.userId = login.id;
  },
  url() {
    return `/api/users/${this.userId}/blocks`;
  },
});

export default BlockCollection;
