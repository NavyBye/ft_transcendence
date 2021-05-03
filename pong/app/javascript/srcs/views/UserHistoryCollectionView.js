import collection from '../collections';
import common from '../common';
import template from '../templates/UserHistoryCollectionView.html';
import UserHistoryView from './UserHistoryView';

const UserHistoryCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#user-history-collection',
  ViewType: UserHistoryView,
  CollectionType: collection.UserHistoryCollection,
});

export default UserHistoryCollectionView;
