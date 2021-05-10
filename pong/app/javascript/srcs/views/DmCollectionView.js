/* eslint-disable no-new */
/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import collection from '../collections';
import common from '../common';
import template from '../templates/DmCollectionView.html';
import DmView from './DmView';
import consumer from '../../channels/consumer';
import model from '../models';

const DmCollectionView = common.CollectionView.extend({
  el: '#side .content',
  template,
  childContainer: '#dm-collection',
  ViewType: DmView,
  CollectionType: collection.DmCollection,
  events: {
    'click #input-chat .submit': 'sendMsg',
    'keypress #input-chat input': 'sendMsgEnter',
  },
  onInitialize() {
    const dmRoomId = this.collection.dmRoomId;
    const view = this;
    this.channel = consumer.subscriptions.create(
      {
        channel: 'DmRoomChannel',
        id: dmRoomId,
      },
      {
        connected() {},
        disconnected() {},
        received(data) {
          const newModel = new model.DmModel(data.data);
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

    $('#dm-collection').scroll(function scroll() {
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
    const prev = new collection.DmCollection(this.collection.dmRoomId, page);

    const ViewType = this.ViewType;
    const childContainer = this.childContainer;
    const subViews = this.subViews;
    const scrollHeight = $('#dm-collection')[0].scrollHeight;
    prev.fetch({
      success() {
        for (let i = prev.models.length - 1; i >= 0; i -= 1) {
          const view = new ViewType({ model: prev.models[i] });
          subViews.push(view);
          Promise.all([$(childContainer).prepend(view.render().el)]);
        }
        const current = $('#dm-collection')[0].scrollHeight;
        $('#dm-collection').scrollTop(current - scrollHeight);
      },
    });
  },
  onDestroy() {
    this.channel.unsubscribe();
  },
  afterAdd() {
    setTimeout(function callback() {
      $('#dm-collection').scrollTop($('#dm-collection')[0].scrollHeight);
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
});

export default DmCollectionView;
