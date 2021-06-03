/* eslint-disable no-new */
import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/LadderTournamentCardView.html';
import OkModalView from './OkModalView';
import ChallengeModalView from './ChallengeModalView';

const LadderTournamentCardView = common.View.extend({
  template,
  events: {},
  onInitialize() {},
  onRender() {},
  click() {
    const login = Radio.channel('login').request('get');
    if (login.get('rank') === 1) {
      new OkModalView().show('Your are king', 'Your are top! wait challenger');
    } else {
      new ChallengeModalView();
    }
  },
});

export default LadderTournamentCardView;
