import $ from 'jquery/src/jquery';
import BootstrapMenu from 'bootstrap-menu';
import Radio from 'backbone.radio';
import common from '../common';
import auth from '../utils/auth';
import template from '../templates/GuildMemberView.html';
import OkModalView from './OkModalView';

const GuildMemberView = common.View.extend({
  template,
  tagName: 'tr',
  className: 'row',
  onInitialize() {
    this.guildId = Radio.channel('guild').request('id');
  },
  onRender() {
    const self = this;
    const isOfficer =
      this.model.get('role') === 'member'
        ? {
            name: 'Give Officer',
            onClick() {
              $.ajax({
                type: 'PUT',
                url: `/api/guilds/${self.guildId}/members/${
                  self.model.get('user').id
                }`,
                headers: auth.getTokenHeader(),
                data: { role: 'officer' },
                success() {
                  new OkModalView().show('Success', 'Successfully change role');
                  Radio.channel('guild').request('reRender');
                },
              });
            },
            classNames: 'dropdown-item',
          }
        : {
            name: 'Get Officer',
            onClick() {
              $.ajax({
                type: 'PUT',
                url: `/api/guilds/${self.guildId}/members/${
                  self.model.get('user').id
                }`,
                headers: auth.getTokenHeader(),
                data: { role: 'member' },
                success() {
                  new OkModalView().show('Success', 'Successfully change role');
                  Radio.channel('guild').request('reRender');
                },
              });
            },
            classNames: 'dropdown-item',
          };
    if (
      this.model.get('role') === 'member' ||
      this.model.get('role') === 'officer'
    ) {
      this.menu = new BootstrapMenu(`[member-id=${this.model.get('id')}]`, {
        actions: [
          isOfficer,
          {
            name: 'Kick',
            onClick() {
              $.ajax({
                type: 'DELETE',
                url: `/api/guilds/${self.guildId}/members/${
                  self.model.get('user').id
                }`,
                headers: auth.getTokenHeader(),
                success() {
                  new OkModalView().show('Success', 'Successfully kick member');
                  Radio.channel('guild').request('reRender');
                },
              });
            },
            classNames: 'dropdown-item',
          },
        ],
      });
    }
  },
});

export default GuildMemberView;
