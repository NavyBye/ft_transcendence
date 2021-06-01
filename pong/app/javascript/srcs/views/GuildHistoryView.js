import common from '../common';
import template from '../templates/GuildHistoryView.html';

const GuildHistoryView = common.View.extend({
  template,
  tagName: 'tr',
  onRender() {},
});

export default GuildHistoryView;
