import Backbone from 'backbone';

const ChatRoomUserModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    chat_room_id: 0,
    user_id: 0,
    role: 1,
    status: 1,
  },
});

export default ChatRoomUserModel;
