/* eslint-disable no-new */
import { Radio } from 'backbone';
import collection from '../collections';
import common from '../common';
import template from '../templates/ChatRoomCollectionView.html';
import ChatRoomView from './ChatRoomView';
import AddChatRoomModalView from './AddChatRoomModalView';

const ChatRoomCollectionView = common.CollectionView.extend({
  template,
  el: '#side .content',
  events: {
    'click #add-chatroom': 'showAddChatRoomModalView',
  },
  childContainer: '#chatroom-collection',
  ViewType: ChatRoomView,
  CollectionType: collection.ChatRoomCollection,
  onInitialize() {
    const chatRoomCollection = this.collection;
    Radio.channel('chatrooms').reply('fetch', function fetch() {
      chatRoomCollection.fetch();
    });
  },
  showAddChatRoomModalView() {
    new AddChatRoomModalView();
  },
});

export default ChatRoomCollectionView;
