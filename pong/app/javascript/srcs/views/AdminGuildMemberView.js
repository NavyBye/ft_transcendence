import $ from 'jquery/src/jquery';
import BootstrapMenu from 'bootstrap-menu';
import common from '../common';
import auth from '../utils/auth';
import template from '../templates/GuildMemberView.html';
import OkModalView from './OkModalView';

const AdminGuildMemberView = common.View.extend({
  template,
  tagName: 'tr',
  className: 'row',
  onInitialize() {},
  onRender() {
    const self = this;
    this.menu = new BootstrapMenu(`[member-id=${this.model.get('id')}]`, {
      actions: [
        {
          name: 'Change to Member',
          onClick() {
            $.ajax({
              type: 'PUT',
              data: { role: 'member' },
              url: `/api/guilds/${self.model.get('guild_id')}/members/${
                self.model.get('user').id
              }`,
              headers: auth.getTokenHeader(),
              success() {
                $('#admin-guild-modal').modal('hide');
                new OkModalView().show('Success', 'Successfully change');
              },
            });
          },
          classNames: 'dropdown-item',
        },
        {
          name: 'Change to Officer',
          onClick() {
            $.ajax({
              type: 'PUT',
              data: { role: 'officer' },
              url: `/api/guilds/${self.model.get('guild_id')}/members/${
                self.model.get('user').id
              }`,
              headers: auth.getTokenHeader(),
              success() {
                $('#admin-guild-modal').modal('hide');
                new OkModalView().show('Success', 'Successfully change');
              },
            });
          },
          classNames: 'dropdown-item',
        },
        {
          name: 'Change to Master',
          onClick() {
            $.ajax({
              type: 'PUT',
              data: { role: 'master' },
              url: `/api/guilds/${self.model.get('guild_id')}/members/${
                self.model.get('user').id
              }`,
              headers: auth.getTokenHeader(),
              success() {
                $('#admin-guild-modal').modal('hide');
                new OkModalView().show('Success', 'Successfully change');
              },
            });
          },
          classNames: 'dropdown-item',
        },
      ],
    });
  },
});

export default AdminGuildMemberView;