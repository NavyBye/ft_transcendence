import common from '../common';
import collection from '../collections';
import ChatRoomUserModalView from './ChatRoomUserModalView';

const ChatRoomUserCollectionModalView = common.CollectionView.extend({
  el: '#chatRoomUserModal',
  childContainer: '#chatroom-user-collection',
  ViewType: ChatRoomUserModalView,
  CollectionType: collection.ChatRoomUserCollection,
  events: {},
  onInitialize() {},
});

export default ChatRoomUserCollectionModalView;
