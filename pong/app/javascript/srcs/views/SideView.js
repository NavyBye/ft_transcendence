import common from '../common';
import template from '../templates/side.html';

const SideView = common.View.extend({
  el: '#side',
  template,
  events: {
    'click .nav-item': 'showTab',
  },
  onRender() {
    this.currentTab = 'chat-tab';
    this.addRegion('content', '#side .content');
  },
  showTab(event) {
    /* change tab */
    event.preventDefault();
    const target = event.target.getAttribute('id');
    this.$(`#${this.currentTab}`).removeClass('active');
    this.$(`#${target}`).addClass('active');
    this.currentTab = target;

    /* attach view to region */
  },
});

export default SideView;
