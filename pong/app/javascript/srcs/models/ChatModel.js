import Backbone from 'backbone';

const ChatModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    name: '',
    body: '',
    created_at: '',
  },
});

export default ChatModel;
