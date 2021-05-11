import Radio from 'backbone.radio';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/GuildView.html';
import auth from '../utils/auth';
import model from '../models';
import YesGuildView from './YesGuildView';
import NoGuildView from './NoGuildView';

const GuildView = common.View.extend({
  template,
  onInitialize() {
    const self = this;
    Radio.channel('guild').reply('reRender', function reRender() {
      self.render();
    });
    this.addRegion('guild_body', '#guild-body');
  },
  onRender() {
    const self = this;
    $.ajax({
      headers: auth.getTokenHeader(),
      type: 'GET',
      url: '/api/guilds/my',
      success(res) {
        $('#guild-body').addClass('yes-guild-body');
        const myGuild = new model.GuildModel(res);
        self.show('guild_body', new YesGuildView({ model: myGuild }));
      },
      error() {
        $('#guild-body').removeClass('yes-guild-body');
        self.show('guild_body', new NoGuildView());
      },
    });
  },
});

export default GuildView;
