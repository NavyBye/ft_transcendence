import Backbone from 'backbone';
import model from '../models';

const GuildWarCollection = Backbone.Collection.extend({
  model: model.GuildWarModel,
  initialize() {},
  url() {
    return `/api/declarations`;
  },
});

export default GuildWarCollection;
