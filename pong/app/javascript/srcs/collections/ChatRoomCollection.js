import Backbone from 'backbone';
import model from '../models';

const ChatRoomCollection = Backbone.Collection.extend({
  model: model.ChatRoomModel,
  url() {
    return `/api/chatrooms`;
  },
});

export default ChatRoomCollection;
