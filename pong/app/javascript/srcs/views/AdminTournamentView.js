import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/AdminTournamentView.html';
import auth from '../utils/auth';
import OkModalView from './OkModalView';

const AdminTournamentView = common.View.extend({
  el: '#admin-content',
  template,
  events: {
    'click #admin-tournament-summit-btn': 'summitTournament',
  },
  onInitialize() {},
  onRender() {
    const agent = navigator.userAgent.toLowerCase();
    if (agent.indexOf('firefox') !== -1) {
      $('#tournament-start-time').attr('type', 'time');
    }
  },
  summitTournament() {
    const data = {};
    const agent = navigator.userAgent.toLowerCase();
    data.title = $('#tournament-name').val();
    data.start_at = $('#tournament-start-time').val();
    if (agent.indexOf('firefox') !== -1) {
      const currentTime = new Date();
      const hours = data.start_at.split(':');
      currentTime.setHours(hours[0]);
      currentTime.setMinutes(hours[1]);
      data.start_at = currentTime;
    }
    data.addon = $('#tournament-add-on').is(':checked');
    data.is_ladder = $('#tournament-ladder').is(':checked');
    data.max_participants = $('#max-participants').val();
    $.ajax({
      type: 'POST',
      url: `/api/tournaments`,
      headers: auth.getTokenHeader(),
      data,
      success() {
        new OkModalView().show('Success', 'Successfully declare');
      },
    });
  },
});

export default AdminTournamentView;
