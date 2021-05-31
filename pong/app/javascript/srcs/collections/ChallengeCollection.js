import Backbone from 'backbone';
import model from '../models';

const ChallengeCollection = Backbone.Collection.extend({
  model: model.UserModel,
  url() {
    return `/api/users/challenge`;
  },
});

export default ChallengeCollection;
