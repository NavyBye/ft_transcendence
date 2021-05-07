import common from '../common';
import template from '../templates/YesGuildView.html';
import GuildInfoView from './GuildInfoView';
import GuildManageView from './GuildManageView';

const YesGuildView = common.View.extend({
  el: '#guild-body',
  template,
  events: {
    'click .nav-item': 'showTab',
  },
  onInitialize() {
    this.addRegion('guildContent', '#guild-content');
  },
  onRender() {
    this.currentTab = 'info-tab';
    this.getRegion('guildContent').show(
      new GuildInfoView({ model: this.model }),
    );
  },
  showTab(event) {
    event.preventDefault();
    const target = event.target.getAttribute('id');
    this.$(`#${this.currentTab}`).removeClass('active');
    this.$(`#${target}`).addClass('active');
    this.currentTab = target;

    if (target === 'info-tab') {
      this.getRegion('guildContent').show(
        new GuildInfoView({ model: this.model }),
      );
    } else if (target === 'manage-tab') {
      this.getRegion('guildContent').show(
        new GuildManageView({ model: this.model }),
      );
    }
  },
});

export default YesGuildView;
