import Radio from 'backbone.radio';
import collection from '../collections';
import common from '../common';
import template from '../templates/FriendCollectionView.html';
import FriendView from './FriendView';

const FriendCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#friend-collection',
  ViewType: FriendView,
  CollectionType: collection.FriendCollection,
  afterAdd() {},
  onRender() {},
  onInitialize() {
    const channel = Radio.channel('friendView');
    this.listenTo(channel, 'refresh', this.refresh);
  },
  refresh() {
    const self = this;
    this.collection.fetch({
      reset: true,
      success() {
        self.reRender();
      },
    });
  },
});

export default FriendCollectionView;
