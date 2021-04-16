import Backbone from 'backbone';

const ChatRoomModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    name: '',
    public: false,
  },
});

export default ChatRoomModel;
