import Backbone from 'backbone';
import model from '../models';

const GuildRankingCollection = Backbone.Collection.extend({
  model: model.GuildModel,
  url() {
    return `/api/guilds/rank`;
  },
});

export default GuildRankingCollection;
