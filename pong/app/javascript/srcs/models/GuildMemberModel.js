import Backbone from 'backbone';

const GuildMemberModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    role: '',
    user: {},
  },
});

export default GuildMemberModel;
