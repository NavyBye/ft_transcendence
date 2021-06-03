import Backbone from 'backbone';
import model from '../models';

const DmCollection = Backbone.Collection.extend({
  model: model.DmModel,
  initialize(dmRoomId, page) {
    this.dmRoomId = dmRoomId;
    this.page = page;
  },
  url() {
    const page = this.page ? `page=${this.page}` : '';
    return `/api/dmrooms/${this.dmRoomId}/messages?${page}`;
  },
  parse(response) {
    this.page = response.page;
    return response.messages;
  },
});

export default DmCollection;
