import Backbone from 'backbone';

const GuildWarModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    from_id: 0,
    to_id: 0,
    end_at: '',
    war_time: 0,
    avoid_chance: 0,
    prize: 0,
    is_extended: false,
    is_addon: false,
  },
});

export default GuildWarModel;
