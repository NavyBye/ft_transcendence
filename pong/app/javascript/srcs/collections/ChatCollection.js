import Backbone from 'backbone';
import model from '../models';

const ChatCollection = Backbone.Collection.extend({
  model: model.ChatModel,
  initialize(chatRoomId) {
    this.chatRoomId = chatRoomId;
  },
  url() {
    return `/api/chatrooms/${this.chatRoomId}/messages`;
  },
});

export default ChatCollection;
