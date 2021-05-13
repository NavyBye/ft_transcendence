import Radio from 'backbone.radio';
import Backbone from 'backbone';
import model from '../models';

const GuildInviteCollection = Backbone.Collection.extend({
  model: model.GuildInviteModel,
  initialize() {
    const me = Radio.channel('login').request('get');
    this.userId = me.get('id');
  },
  url() {
    return `/api/users/${this.userId}/invites`;
  },
});

export default GuildInviteCollection;
