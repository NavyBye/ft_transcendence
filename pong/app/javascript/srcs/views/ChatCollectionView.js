/* eslint-disable for-direction */
/* eslint-disable no-new */
/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import collection from '../collections';
import common from '../common';
import template from '../templates/ChatCollectionView.html';
import ChatView from './ChatView';
import consumer from '../../channels/consumer';
import model from '../models';
import ChatRoomSettingModalView from './ChatRoomSettingModalView';
import ChatRoomUserCollectionModalView from './ChatRoomUserCollectionModalView';

const ChatCollectionView = common.CollectionView.extend({
  el: '#side .content',
  template,
  childContainer: '#chat-collection',
  ViewType: ChatView,
  CollectionType: collection.ChatCollection,
  events: {
    'click #chatroom-setting-button': 'showChatRoomSettingModalView',
    'click #chat-user-button': 'showUserModal',
    'click #input-chat .submit': 'sendMsg',
    'keypress #input-chat input': 'sendMsgEnter',
  },
  onInitialize() {
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
          const newModel = new model.ChatModel(data.data);
          view.add(newModel);
        },
      },
    );
  },
  onRender() {
    const view = this;
    if (this.$el.scrollTop() === 0) {
      view.pageUp();
    }

    $('#chat-collection').scroll(function scroll() {
      const position = $(this).scrollTop();
      if (position === 0) {
        view.pageUp();
      }
    });
  },
  pageUp() {
    if (!this.collection.page || this.collection.page <= 0) return;

    /* get previous page */
    this.collection.page -= 1;
    const page = this.collection.page;
    const prev = new collection.ChatCollection(
      this.collection.chatRoomId,
      page,
    );

    const ViewType = this.ViewType;
    const childContainer = this.childContainer;
    const subViews = this.subViews;
    const scrollHeight = $('#chat-collection')[0].scrollHeight;
    prev.fetch({
      success() {
        for (let i = prev.models.length - 1; i >= 0; i -= 1) {
          const view = new ViewType({ model: prev.models[i] });
          subViews.push(view);
          Promise.all([$(childContainer).prepend(view.render().el)]);
        }
        const current = $('#chat-collection')[0].scrollHeight;
        $('#chat-collection').scrollTop(current - scrollHeight);
      },
    });
  },
  onDestroy() {
    this.channel.unsubscribe();
  },
  afterAdd() {
    setTimeout(function callback() {
      $('#chat-collection').scrollTop($('#chat-collection')[0].scrollHeight);
    }, 0.25);
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
  showChatRoomSettingModalView() {
    new ChatRoomSettingModalView({ chatRoomId: this.collection.chatRoomId });
  },
  showUserModal() {
    new ChatRoomUserCollectionModalView(this.collection.chatRoomId);
    $('#chatRoomUserModal').modal('show');
  },
});

export default ChatCollectionView;
