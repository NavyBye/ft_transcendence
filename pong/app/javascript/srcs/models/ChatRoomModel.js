import Backbone from 'backbone';

const ChatRoomModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    name: '',
    public: false,
    joined: false,
  },
});

export default ChatRoomModel;
