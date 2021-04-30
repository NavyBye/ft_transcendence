import Backbone from 'backbone';
import model from '../models';

const GuildRankingCollection = Backbone.Collection.extend({
  model: model.GuildRankingModel,
  url() {
    return `/api/guilds/rank`;
  },
});

export default GuildRankingCollection;
