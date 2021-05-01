import Backbone from 'backbone';
import model from '../models';

const UserRankingCollection = Backbone.Collection.extend({
  model: model.UserRankingModel,
  comparator: 'rank',
  initialize() {},
  url() {
    return `/api/users/rank`;
  },
});

export default UserRankingCollection;
