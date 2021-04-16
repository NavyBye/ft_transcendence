import collection from '../collections';
import common from '../common';
import template from '../templates/DmRoomCollectionView.html';
import DmRoomView from './DmRoomView';

const DmRoomCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#dmroom-collection',
  ViewType: DmRoomView,
  CollectionType: collection.DmRoomCollection,
});

export default DmRoomCollectionView;
