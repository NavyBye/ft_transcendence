import Radio from 'backbone.radio';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/GuildInviteView.html';
import auth from '../utils/auth';

const GuildInviteView = common.View.extend({
  template,
  events: {
    'click .o-button': 'inviteAccept',
    'click .x-button': 'inviteRefuse',
  },
  onRender() {},
  inviteAccept() {
    const user = Radio.channel('login').request('get');
    $.ajax({
      type: 'PUT',
      url: `/api/users/${user.get('id')}/invites/${this.model.get('id')}`,
      headers: auth.getTokenHeader(),
      success() {
        Radio.channel('guild').request('reRender');
      },
    });
  },
  inviteRefuse() {
    const user = Radio.channel('login').request('get');
    $.ajax({
      type: 'DELETE',
      url: `/api/users/${user.get('id')}/invites/${this.model.get('id')}`,
      headers: auth.getTokenHeader(),
      success() {
        Radio.channel('guild').request('reRender');
      },
    });
  },
});

export default GuildInviteView;
