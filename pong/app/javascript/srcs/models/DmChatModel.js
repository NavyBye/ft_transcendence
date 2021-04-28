import Backbone from 'backbone';

const DmChatModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    name: '',
    body: '',
    created_at: '',
  },
});

export default DmChatModel;
