import Backbone from 'backbone';
import model from '../models';

const DmRoomCollection = Backbone.Collection.extend({
  model: model.DmRoomModel,
  url() {
    return `/api/dmrooms`;
  },
});

export default DmRoomCollection;
