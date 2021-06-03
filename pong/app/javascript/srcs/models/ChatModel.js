import Backbone from 'backbone';

const ChatModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    type: 'message',
    body: '',
    created_at: '',
    user: {},
  },
});

export default ChatModel;
