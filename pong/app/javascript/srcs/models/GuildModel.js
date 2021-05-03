import Backbone from 'backbone';

const GuildModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    name: '',
    point: 1,
    point_rank: 1,
  },
});

export default GuildModel;
