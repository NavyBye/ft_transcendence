import common from '../common';
import template from '../templates/GuildMemberView.html';

const GuildMemberView = common.View.extend({
  el: '#guild-member-collection',
  template,
  onRender() {},
});

export default GuildMemberView;
