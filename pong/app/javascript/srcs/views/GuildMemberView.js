import $ from 'jquery/src/jquery';
import BootstrapMenu from 'bootstrap-menu';
import Radio from 'backbone.radio';
import common from '../common';
import auth from '../utils/auth';
import template from '../templates/GuildMemberView.html';

const GuildMemberView = common.View.extend({
  el: '#guild-member-collection',
  template,
  onInitialize() {
    this.guildId = Radio.channel('guild').request('id');
  },
  onRender() {
    const self = this;
    this.menu = new BootstrapMenu(`[member-id=${this.model.get('id')}]`, {
      actions: [
        {
          name: 'Kick',
          onClick() {
            $.ajax({
              type: 'DELETE',
              url: `/api/guilds/${self.guildId}/members/${self.model.get(
                'id',
              )}`,
              headers: auth.getTokenHeader(),
            });
          },
          classNames: 'dropdown-item',
        },
      ],
    });
  },
});

export default GuildMemberView;
