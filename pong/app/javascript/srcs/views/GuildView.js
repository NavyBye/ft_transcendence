import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/GuildView.html';
import auth from '../utils/auth';
import model from '../models';
import YesGuildView from './YesGuildView';
import NoGuildView from './NoGuildView';

const GuildView = common.View.extend({
  el: '#content',
  template,
  onInitialize() {
    this.addRegion('guild_body', '#guild-body');
  },
  onRender() {
    $.ajax({
      headers: auth.getTokenHeader(),
      type: 'GET',
      url: '/api/guilds/my',
      success(res) {
        const myGuild = new model.GuildModel(res);
        this.show('guild_body', new YesGuildView(myGuild));
      },
      error() {
        this.show('guild_body', new NoGuildView());
      },
    });
  },
});

export default GuildView;
