import $ from 'jquery/src/jquery';
import BootstrapMenu from 'bootstrap-menu';
import Radio from 'backbone.radio';
import common from '../common';
import auth from '../utils/auth';
import template from '../templates/GuildMemberView.html';
import OkModalView from './OkModalView';

const GuildMemberView = common.View.extend({
  template,
  onInitialize() {
    this.guildId = Radio.channel('guild').request('id');
  },
  onRender() {
    const isOfficer =
      this.model.get('role') === 'member'
        ? {
            name: 'Give Officer',
            onClick() {
              $.ajax({
                type: 'PUT',
                url: `/api/guilds/${this.guildId}/members/${this.model.get(
                  'id',
                )}`,
                headers: auth.getTokenHeader(),
                data: { role: 'officer' },
                success() {
                  new OkModalView().show('Success', 'Successfully change role');
                },
                error(res) {
                  Radio.channel('error').request('trigger', res.responseText);
                },
              });
            },
          }
        : {
            name: 'Get Officer',
            onClick() {
              $.ajax({
                type: 'PUT',
                url: `/api/guilds/${this.guildId}/members/${this.model.get(
                  'id',
                )}`,
                headers: auth.getTokenHeader(),
                data: { role: 'member' },
                success() {
                  new OkModalView().show('Success', 'Successfully change role');
                },
                error(res) {
                  Radio.channel('error').request('trigger', res.responseText);
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
                url: `/api/guilds/${this.guildId}/members/${this.model.get(
                  'id',
                )}`,
                headers: auth.getTokenHeader(),
                success() {
                  new OkModalView().show('Success', 'Successfully kick member');
                },
                error(res) {
                  Radio.channel('error').request('trigger', res.responseText);
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
