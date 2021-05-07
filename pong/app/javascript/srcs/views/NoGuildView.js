import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/NoGuildView.html';
import GuildInviteCollectionView from './GuildInviteCollectionView';
import auth from '../utils/auth';
import OkModalView from './OkModalView';

const NoGuildView = common.View.extend({
  el: '#guild-body',
  template,
  events: {
    'click #guild-create-button': 'guildCreate',
  },
  onInitialize() {
    this.addRegion('guild_invite', '#guild-invite-body');
  },
  onRender() {
    this.show('guild_invite', new GuildInviteCollectionView());
  },
  guildCreate() {
    const data = {};
    data.name = $('#guild_name').val();
    data.anagram = $('#anagram').val();
    $.ajax({
      type: 'POST',
      url: `/api/guilds`,
      headers: auth.getTokenHeader(),
      data,
      success() {
        new OkModalView().show('Success', 'Successfully create guild');
        Radio.channel('guild').request('reRender');
      },
      error(res) {
        Radio.channel('error').request('trigger', res.responseText);
      },
    });
  },
});

export default NoGuildView;
