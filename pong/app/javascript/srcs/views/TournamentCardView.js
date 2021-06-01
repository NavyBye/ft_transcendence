import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/TournamentCardView.html';
import auth from '../utils/auth';
import OkModalView from './OkModalView';

const TournamentCardView = common.View.extend({
  template,
  events: {},
  onInitialize() {},
  onRender() {},
  click() {
    $.ajax({
      type: 'POST',
      url: '/api/tournaments/participants',
      headers: auth.getTokenHeader(),
      success() {
        new OkModalView().show('Success', 'Success apply tournament');
      },
    });
  },
});

export default TournamentCardView;
