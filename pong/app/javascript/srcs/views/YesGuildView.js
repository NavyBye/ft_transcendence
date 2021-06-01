import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/YesGuildView.html';
import GuildInfoView from './GuildInfoView';
import GuildManageView from './GuildManageView';
import GuildHistoryCollectionView from './GuildHistoryCollectionView';

const YesGuildView = common.View.extend({
  el: '#guild-body',
  template,
  events: {
    'click .nav-item': 'showTab',
  },
  onInitialize() {
    const self = this;
    this.addRegion('guildContent', '#guild-content');
    Radio.channel('guild').reply('id', function getter() {
      return self.model.get('id');
    });
  },
  onRender() {
    this.currentTab = 'info-tab';
    this.getRegion('guildContent').show(
      new GuildInfoView({ model: this.model }),
    );
  },
  showTab(event) {
    event.preventDefault();
    const user = Radio.channel('login').request('get');
    const target = event.target.getAttribute('id');
    if (target === 'info-tab') {
      this.changeActive(target);
      this.getRegion('guildContent').show(
        new GuildInfoView({ model: this.model }),
      );
    } else if (target === 'guild-history-tab') {
      this.changeActive(target);
      this.getRegion('guildContent').show(
        new GuildHistoryCollectionView(this.model.get('id')),
      );
    } else if (
      target === 'manage-tab' &&
      user.id === this.model.get('master').id
    ) {
      this.changeActive(target);
      this.getRegion('guildContent').show(
        new GuildManageView({ model: this.model }),
      );
    }
  },
  changeActive(target) {
    this.$(`#${this.currentTab}`).removeClass('active');
    this.$(`#${target}`).addClass('active');
    this.currentTab = target;
  },
});

export default YesGuildView;
