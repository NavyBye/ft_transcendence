import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import common from '../common';
import auth from '../utils/auth';
import template from '../templates/GuildInfoView.html';
import GuildMemberCollectionView from './GuildMemberCollectionView';
import OkModalView from './OkModalView';

const GuildInfoView = common.View.extend({
  el: '#guild-body',
  template,
  events: {
    'click #guild-out-btn': 'guildOut',
  },
  onInitialize() {
    this.addRegion('guild_member', '#guild-member');
  },
  onRender() {
    this.show(
      'guild_member',
      new GuildMemberCollectionView({ model: this.model }),
    );
  },
  guildOut() {
    const userId = Radio.channel('login').request('get').id;
    $.ajax({
      type: 'DELETE',
      url: `/api/guilds/${this.model.get('id')}/members/${userId}`,
      headers: auth.getTokenHeader(),
      success() {
        new OkModalView().show('Success', 'Successfully Leave the guild');
        Radio.channel('guild').request('reRender');
      },
    });
  },
});

export default GuildInfoView;
