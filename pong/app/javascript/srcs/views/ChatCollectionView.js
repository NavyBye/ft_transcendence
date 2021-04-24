/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import collection from '../collections';
import common from '../common';
import template from '../templates/ChatCollectionView.html';
import ChatView from './ChatView';
import consumer from '../../channels/consumer';
import model from '../models';

const ChatCollectionView = common.CollectionView.extend({
  el: '#side .content',
  template,
  childContainer: '#chat-collection',
  ViewType: ChatView,
  CollectionType: collection.ChatCollection,
  events: {
    'click #input-chat .submit': 'sendMsg',
    'keypress #input-chat input': 'sendMsgEnter',
  },
  onInitialize() {
    window.comsumer = consumer;
    const chatRoomId = this.collection.chatRoomId;
    const view = this;
    this.channel = consumer.subscriptions.create(
      {
        channel: 'ChatRoomChannel',
        id: chatRoomId,
      },
      {
        connected() {},
        disconnected() {},
        received(data) {
          const newModel = new model.ChatModel(JSON.parse(data.data));
          view.add(newModel);
        },
      },
    );
  },
  onDestroy() {
    this.channel.unsubscribe();
  },
  afterAdd() {
    $('#chat-collection').scrollTop($('#chat-collection')[0].scrollHeight);
  },
  sendMsg() {
    const body = $('#input-chat input').val();
    if (body.length > 0) {
      $('#input-chat input').val('');
      this.channel.send({ body });
    }
  },
  sendMsgEnter(event) {
    if (event.which === 13) {
      const body = $('#input-chat input').val();
      if (body.length > 0) {
        $('#input-chat input').val('');
        this.channel.send({ body });
      }
    }
  },
});

export default ChatCollectionView;
