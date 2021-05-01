import Backbone from 'backbone';

const GuildModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    name: '',
    rating: 1,
  },
});

export default GuildModel;
