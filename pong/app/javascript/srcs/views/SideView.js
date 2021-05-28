import Radio from 'backbone.radio';
import view from '.';
import common from '../common';
import template from '../templates/SideView.html';

const SideView = common.View.extend({
  el: '#side',
  template,
  events: {
    'click .nav-item': 'showTab',
  },
  onInitialize() {
    const channel = Radio.channel('side');
    this.listenTo(channel, 'enter-chatroom', this.enterChatRoom);
    this.listenTo(channel, 'enter-dmroom', this.enterDmRoom);
    this.addRegion('content', '#side .content');
    const self = this;

    Radio.channel('side').reply('changeTab', function changeTab(target) {
      /* attach view to region */
      self.$(`#${self.currentTab}`).removeClass('active');
      self.$(`#${target}`).addClass('active');
      if (target === 'chat-tab') {
        self.getRegion('content').show(new view.ChatRoomCollectionView());
      } else if (target === 'dm-tab') {
        self.getRegion('content').show(new view.DmRoomCollectionView());
      } else if (target === 'friend-tab') {
        const login = Radio.channel('login').request('get');
        self
          .getRegion('content')
          .show(new view.FriendCollectionView({ userId: login.get('id') }));
      }
    });

    Radio.channel('side').reply('refresh', function refresh() {
      Radio.channel('side').request('changeTab', self.currentTab);
    });
  },
  onRender() {
    this.currentTab = 'chat-tab';
    this.getRegion('content').show(new view.ChatRoomCollectionView());
  },
  onDestroy() {
    this.getRegion('content').getView().destroy();
  },
  showTab(event) {
    /* change tab */
    event.preventDefault();
    const target = event.target.getAttribute('id');
    Radio.channel('side').request('changeTab', target);
    this.currentTab = target;
  },
  enterChatRoom(chatRoomId) {
    this.getRegion('content').show(new view.ChatCollectionView(chatRoomId));
  },
  enterDmRoom(dmRoomId) {
    this.getRegion('content').show(new view.DmCollectionView(dmRoomId));
  },
});

export default SideView;
