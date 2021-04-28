import $ from 'jquery/src/jquery';
import collection from '../collections';
import common from '../common';
import template from '../templates/ChatCollectionView.html';
import ChatView from './ChatView';

const ChatCollectionView = common.CollectionView.extend({
  el: '#side .content',
  template,
  childContainer: '#chat-collection',
  ViewType: ChatView,
  CollectionType: collection.ChatCollection,
  onInitialize() {},
  onRender() {},
  afterAdd() {
    $('#chat-collection').scrollTop($('#chat-collection')[0].scrollHeight);
  },
});

export default ChatCollectionView;
