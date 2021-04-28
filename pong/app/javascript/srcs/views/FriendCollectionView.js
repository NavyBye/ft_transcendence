import collection from '../collections';
import common from '../common';
import template from '../templates/FriendCollectionView.html';
import FriendView from './FriendView';

const FriendCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#friend-collection',
  ViewType: FriendView,
  CollectionType: collection.FriendCollection,
  onRender() {},
});

export default FriendCollectionView;
