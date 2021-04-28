import Backbone from 'backbone';

const DmModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    dm_room_id: 0,
    user_id: 0,
    body: '',
    created_at: '',
  },
});

export default DmModel;
