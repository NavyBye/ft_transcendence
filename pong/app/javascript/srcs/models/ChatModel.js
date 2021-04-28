import Backbone from 'backbone';

const ChatModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    body: '',
    created_at: '',
    user_id: 0,
    user_nickname: '',
  },
  parse(response) {
    response.user_id = response.user.id;
    response.user_nickname = response.user.nickname;
    return response;
  },
});

export default ChatModel;
