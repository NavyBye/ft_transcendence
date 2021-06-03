/* eslint-disable no-new */
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/GuildManageView.html';
import auth from '../utils/auth';
import GuildWarTimeModalView from './GuildWarTimeModalView';
import GuildWarCollectionView from './GuildWarCollectionView';
import OkModalView from './OkModalView';

const GuildManageView = common.View.extend({
  el: '#guild-body',
  template,
  events: {
    'click #war-time': 'showGuildWarTimeModalView',
    'click #guild-war-declare-btn': 'warDeclare',
  },
  onInitialize() {
    this.addRegion('guild_war', '#guild-war-invite');
  },
  onRender() {
    const agent = navigator.userAgent.toLowerCase();
    if (agent.indexOf('firefox') !== -1) {
      $('#end-date').attr('type', 'date');
    }
    this.show('guild_war', new GuildWarCollectionView());
  },
  showGuildWarTimeModalView() {
    new GuildWarTimeModalView();
  },
  warDeclare() {
    const data = {};
    const agent = navigator.userAgent.toLowerCase();
    data.to_guild = $('#guild-name').val();

    data.end_at = $('#end-date').val();
    if (agent.indexOf('firefox') !== -1) {
      const currentTime = new Date(data.end_at);
      data.end_at = currentTime;
    }
    data.war_time = $('#war-time').attr('time');
    data.avoid_chance = $('#avoid-chance').val();
    data.prize_point = $('#prize').val();
    data.tta = $('#tta').val();
    data.is_extended = $('#is-extended').is(':checked');
    data.is_addon = $('#is-add-on').is(':checked');
    $.ajax({
      type: 'POST',
      url: `/api/declarations`,
      headers: auth.getTokenHeader(),
      data,
      success() {
        new OkModalView().show('Success', 'Successfully declare');
      },
    });
  },
});

export default GuildManageView;
