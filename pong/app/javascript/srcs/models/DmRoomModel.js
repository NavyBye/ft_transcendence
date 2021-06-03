import Backbone from 'backbone';

const DmRoomModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    name: '',
  },
});

export default DmRoomModel;
