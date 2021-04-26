import Backbone from 'backbone';
import model from '../models';

const ChatCollection = Backbone.Collection.extend({
  model: model.ChatModel,
  initialize(chatRoomId, page) {
    this.chatRoomId = chatRoomId;
    this.page = page;
  },
  url() {
    const page = this.page ? `page=${this.page}` : '';
    return `/api/chatrooms/${this.chatRoomId}/messages?${page}`;
  },
  parse(response) {
    this.page = response.page;
    return response.messages;
  },
});

export default ChatCollection;
