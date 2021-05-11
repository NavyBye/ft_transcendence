/* eslint-disable no-new */
import common from '../common';
import template from '../templates/GuildManageView.html';
import GuildWarTimeModalView from './GuildWarTimeModalView';

const GuildManageView = common.View.extend({
  el: '#guild-body',
  template,
  events: {
    'click #war-time': 'showGuildWarTimeModalView',
  },
  onInitialize() {},
  onRender() {},
  showGuildWarTimeModalView() {
    new GuildWarTimeModalView();
  },
});

export default GuildManageView;
