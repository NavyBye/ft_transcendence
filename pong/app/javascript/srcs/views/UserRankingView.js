/* eslint-disable no-new */
import common from '../common';
import template from '../templates/UserRankingView.html';
import UserProfileModalView from './UserProfileModalView';

const UserRankingView = common.View.extend({
  template,
  events: {
    'click .nickname': 'showProfile',
  },
  onRender() {},
  showProfile() {
    new UserProfileModalView(this.model.get('id'));
  },
});

export default UserRankingView;
