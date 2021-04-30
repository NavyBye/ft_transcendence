import collection from '../collections';
import common from '../common';
import template from '../templates/UserRankingCollectionView.html';
import UserRankingView from './UserRankingView';

const UserRankingCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#user-ranking-collection',
  ViewType: UserRankingView,
  CollectionType: collection.UserRankingCollection,
  onRender() {},
});

export default UserRankingCollectionView;
