import Backbone from 'backbone';

const GuildInviteModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    guild: {},
  },
});

export default GuildInviteModel;
