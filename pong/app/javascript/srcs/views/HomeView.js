/* eslint-disable no-param-reassign */
/* eslint-disable prefer-destructuring */
import { Radio } from 'backbone';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/HomeView.html';
import auth from '../utils/auth';

const HomeView = common.View.extend({
  template,
  onRender() {
    Radio.channel('guildwar').reply('notify', function notify() {
      $('#guild-war-text').text('SOMEONE IS WAITING FOR GUILD WAR!');
    });

    $.ajax({
      type: 'GET',
      url: '/api/wars',
      headers: auth.getTokenHeader(),
      success(data) {
        if (data.length > 0) {
          data = data[0];
          const text = `it's war time.
          ${data.guilds[0].name} vs ${data.guilds[1].name}`;
          $('#guild-war-text').text(text);
        }
      },
    });

    $.ajax({
      type: 'GET',
      url: '/api/tournaments',
      headers: auth.getTokenHeader(),
      success(data) {
        if (data && data.id) {
          const text = `There's active tournament.`;
          $('#tournament-text').text(text);
        }
      },
    });
  },
});

export default HomeView;
