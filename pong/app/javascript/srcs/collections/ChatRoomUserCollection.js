import Backbone from 'backbone';
import model from '../models';

const ChatRoomUserCollection = Backbone.Collection.extend({
  model: model.ChatRoomUserModel,
  initialize(obj) {
    this.chatRoomId = obj;
  },
  url() {
    return `/api/chatrooms/${this.chatRoomId}/members`;
  },
});

export default ChatRoomUserCollection;
