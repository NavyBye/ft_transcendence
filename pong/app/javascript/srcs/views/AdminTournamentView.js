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
  onRender() {},
  summitTournament() {
    const data = {};
    data.title = $('#tournament-name').val();
    data.start_at = $('#tournament-start-time').val();
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
