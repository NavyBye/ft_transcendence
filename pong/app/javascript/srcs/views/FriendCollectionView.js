import collection from '../collections';
import common from '../common';
import template from '../templates/FriendCollectionView.html';
import FriendView from './FriendView';
import consumer from '../../channels/consumer';

const FriendCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#friend-collection',
  ViewType: FriendView,
  CollectionType: collection.FriendCollection,
  afterAdd(m) {
    this.channel = consumer.subscriptions.create(
      {
        channel: 'FriendChannel',
        id: m.get('id'),
      },
      {
        connected() {
          console.log('tt');
        },
        disconnected() {
          console.log('dis con');
        },
        received(data) {
          console.log(data);
        },
      },
    );
  },
  onRender() {},
});

export default FriendCollectionView;
