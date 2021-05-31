import Backbone from 'backbone';
import model from '../models';

const GuildCollection = Backbone.Collection.extend({
  model: model.GuildModel,
  url() {
    return `/api/guilds`;
  },
});

export default GuildCollection;
