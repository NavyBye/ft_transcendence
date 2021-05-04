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
    this.listenTo(channel, 'enter-chatroom', this.enterRoom);
    this.addRegion('content', '#side .content');
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
    this.$(`#${this.currentTab}`).removeClass('active');
    this.$(`#${target}`).addClass('active');
    this.currentTab = target;

    /* attach view to region */
    if (target === 'chat-tab') {
      this.getRegion('content').show(new view.ChatRoomCollectionView());
    } else if (target === 'dm-tab') {
      this.getRegion('content').show(new view.DmRoomCollectionView());
    } else if (target === 'friend-tab') {
      const login = Radio.channel('login').request('get');
      this.getRegion('content').show(
        new view.FriendCollectionView({ userId: login.get('id') }),
      );
    }
  },
  enterRoom(chatRoomId) {
    this.getRegion('content').show(new view.ChatCollectionView(chatRoomId));
  },
});

export default SideView;
