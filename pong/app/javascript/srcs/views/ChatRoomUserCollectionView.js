/* eslint-disable no-new */
import common from '../common';
import template from '../templates/ChatRoomUserCollectionView.html';
import ChatRoomUserView from './ChatRoomUserView';
import collection from '../collections';

const ChatRoomUserCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#chatroom-user-collection',
  ViewType: ChatRoomUserView,
  CollectionType: collection.ChatRoomUserCollection,
  onInitialize(obj) {
    this.chatRoomId = obj;
  },
});

export default ChatRoomUserCollectionView;
