import Backbone from 'backbone';

const UserModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    nickname: '',
    name: '',
    rating: 0,
  },
  url() {
    return `/api/users/${this.userId}`;
  },
});

export default UserModel;
