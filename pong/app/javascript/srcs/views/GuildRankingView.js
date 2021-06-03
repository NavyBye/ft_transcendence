/* eslint-disable no-new */
import common from '../common';
import template from '../templates/GuildRankingView.html';
import GuildHistoryModalView from './GuildHistoryModalView';

const GuildRankingView = common.View.extend({
  template,
  events: {
    'click .rank-text': 'showHistory',
  },
  onRender() {},
  showHistory() {
    new GuildHistoryModalView({ model: this.model });
  },
});

export default GuildRankingView;
