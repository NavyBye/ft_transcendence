import Backbone from 'backbone';
import model from '../models';

const DmCollection = Backbone.Collection.extend({
  model: model.DmModel,
  initialize(dmRoomId) {
    this.dmRoomId = dmRoomId;
  },
  url() {
    return `/api/dmrooms/${this.dmRoomId}/messages`;
  },
});

export default DmCollection;
