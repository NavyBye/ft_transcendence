import Backbone from 'backbone';
import model from '../models';

const GuildMemberCollection = Backbone.Collection.extend({
  model: model.GuildMemberModel,
  initialize(obj) {
    this.guildId = obj.model.get('id');
  },
  url() {
    return `/api/guilds/${this.guildId}/members`;
  },
});

export default GuildMemberCollection;
