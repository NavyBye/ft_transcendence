import Backbone from 'backbone';
import model from '../models';

const ChatRoomUserCollection = Backbone.Collection.extend({
  model: model.ChatRoomUserModel,
  initialize(chatRoomId) {
    this.chatRoomId = chatRoomId;
  },
  url() {
    return `/api/chatrooms/${this.chatRoomId}/members`;
  },
});

export default ChatRoomUserCollection;
