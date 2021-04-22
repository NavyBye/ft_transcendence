import collection from '../collections';
import common from '../common';
import template from '../templates/DmCollectionView.html';
import DmView from './DmView';

const DmCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#dm-collection',
  ViewType: DmView,
  CollectionType: collection.DmCollection,
  onRender() {},
});

export default DmCollectionView;
