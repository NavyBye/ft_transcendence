import Backbone from 'backbone';

const UserModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    nickname: '',
    name: '',
    rating: 0,
    status: 0,
    rating_rank: 1,
  },
  url() {
    const id = this.get('id');
    return `/api/users/${id}`;
  },
});

export default UserModel;
