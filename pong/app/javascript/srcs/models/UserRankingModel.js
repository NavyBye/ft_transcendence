import Backbone from 'backbone';

const UserRankingModel = Backbone.Model.extend({
  defaults: {
    id: 0,
    nickname: '',
    rating: 1,
    rank: 0,
  },
});

export default UserRankingModel;
