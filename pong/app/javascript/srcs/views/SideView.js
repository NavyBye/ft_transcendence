import view from '.';
import common from '../common';
import template from '../templates/SideView.html';

const SideView = common.View.extend({
  el: '#side',
  template,
  events: {
    'click .nav-item': 'showTab',
  },
  onRender() {
    this.addRegion('content', '#side .content');

    this.currentTab = 'chat-tab';
    this.getRegion('content').show(new view.ChatRoomCollectionView());
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
      this.getRegion('content').show(new view.FriendCollectionView());
    }
  },
});

export default SideView;
