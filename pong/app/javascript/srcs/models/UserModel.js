import Backbone from 'backbone';

const UserModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    nickname: '',
    name: '',
    rating: 0,
  },
  initialize(userId) {
    this.userId = userId;
  },
  url() {
    return `/api/users/${this.userId}`;
  },
});

export default UserModel;
