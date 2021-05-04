import collection from '../collections';
import common from '../common';
import template from '../templates/UserRankingCollectionView.html';
import UserRankingView from './UserRankingView';

const UserRankingCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#user-ranking-collection',
  ViewType: UserRankingView,
  CollectionType: collection.UserRankingCollection,
  onInitialize() {},
  onRender() {},
  afterAdd() {
    let rank = 1;
    this.collection.each(function setRank(model) {
      model.set({ rating_rank: rank });
      rank += 1;
    });
  },
});

export default UserRankingCollectionView;
