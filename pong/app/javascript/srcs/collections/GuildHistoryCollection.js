import Backbone from 'backbone';
import model from '../models';

const GuildHistoryCollection = Backbone.Collection.extend({
  model: model.GuildHistoryModel,
  initialize(guildId) {
    this.guildId = guildId;
  },
  url() {
    return `api/guilds/${this.guildId}/histories`;
  },
});

export default GuildHistoryCollection;
