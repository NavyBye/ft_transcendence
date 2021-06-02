/* eslint-disable no-param-reassign */
/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/HomeView.html';
import auth from '../utils/auth';

const HomeView = common.View.extend({
  template,
  onRender() {
    $.ajax({
      type: 'GET',
      url: '/api/wars',
      headers: auth.getTokenHeader(),
      success(data) {
        if (data.length > 0) {
          data = data[0];
          const text = `it's war time. <br>
          ${data.guilds[0].name} vs ${data.guilds[1].name}`;
          $('#guild-war-text').text(text);
          $('#guild-war-img').attr('src', '/images/war.png');
        }
      },
    });
  },
});

export default HomeView;
