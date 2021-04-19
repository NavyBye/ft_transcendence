import collection from '../collections';
import common from '../common';
import template from '../templates/ChatCollectionView.html';
import ChatView from './ChatView';

const ChatCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#chat-collection',
  ViewType: ChatView,
  CollectionType: collection.ChatCollection,
  onRender() {},
});

export default ChatCollectionView;
