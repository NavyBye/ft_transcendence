import Backbone from 'backbone';
import model from '../models';

const UserCollection = Backbone.Collection.extend({
  model: model.UserModel,
  url() {
    return `/api/users`;
  },
});

export default UserCollection;
