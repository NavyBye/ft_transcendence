import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/AdminView.html';
import AdminUserCollectionView from './AdminUserCollectionView';
import AdminGuildCollectionView from './AdminGuildCollectionView';
import AdminTournamentView from './AdminTournamentView';

const YesGuildView = common.View.extend({
  el: '#content',
  template,
  events: {
    'click .nav-item': 'showTab',
  },
  onInitialize() {
    const self = this;
    this.addRegion('adminContent', '#admin-content');
    Radio.channel('admin').reply('reRender', function reRender() {
      self.render();
    });
  },
  onRender() {
    this.currentTab = 'user-tab';
    this.getRegion('adminContent').show(new AdminUserCollectionView());
  },
  showTab(event) {
    event.preventDefault();
    const target = event.target.getAttribute('id');
    this.$(`#${this.currentTab}`).removeClass('active');
    this.$(`#${target}`).addClass('active');
    this.currentTab = target;

    if (target === 'user-tab') {
      this.getRegion('adminContent').show(new AdminUserCollectionView());
    } else if (target === 'guild-tab') {
      this.getRegion('adminContent').show(new AdminGuildCollectionView());
    } else {
      this.getRegion('adminContent').show(new AdminTournamentView());
    }
  },
});

export default YesGuildView;
