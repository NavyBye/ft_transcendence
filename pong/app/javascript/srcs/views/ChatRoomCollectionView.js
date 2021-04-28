import collection from '../collections';
import common from '../common';
import template from '../templates/ChatRoomCollectionView.html';
import ChatRoomView from './ChatRoomView';

const ChatRoomCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#chatroom-collection',
  ViewType: ChatRoomView,
  CollectionType: collection.ChatRoomCollection,
});

export default ChatRoomCollectionView;
