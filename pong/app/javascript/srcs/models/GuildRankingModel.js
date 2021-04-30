import Backbone from 'backbone';

const GuildRankingModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    name: '',
    rating: 1,
  },
});

export default GuildRankingModel;
