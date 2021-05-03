import Radio from 'backbone.radio';
import $ from 'jquery/src/jquery';
import common from '../common';
import UserInfoView from './UserInfoView';
import UserHistoryCollectionView from './UserHistoryCollectionView';
import model from '../models';
import auth from '../utils/auth';

const UserProfileModalView = common.View.extend({
  el: '#user-profile-modal',
  events: {
    'click #add-friend-button': 'addFriend',
    'click #block-button': 'block',
    'click #request-pong-button': 'requestPong',
    'click #guild-invite-button': 'guildInvite',
    'click #dm-button': 'dm',
  },
  onInitialize(obj) {
    this.userId = obj;
    this.addRegion('userinfo', '#user-info');
    this.addRegion('userhistory', '#user-history');
    const user = new model.UserModel({ id: this.userId });

    const self = this;
    user.fetch({
      success() {
        self.show('userinfo', new UserInfoView({ model: user }));
        self.show('userhistory', new UserHistoryCollectionView(self.userId));
      },
    });
    $(this.el).modal('show');
    $(this.el).on('hide.bs.modal', function destroy() {
      self.destroy();
    });
  },
  onRender() {},
  onDestroy() {},
  addFriend() {
    console.log('add_friend btn');
    const login = Radio.channel('login').request('get');
    $.ajax({
      type: 'POST',
      url: `/api/users/${login.get('id')}/friends`,
      headers: auth.getTokenHeader(),
      data: { follow_id: this.userId },
    });
  },
  block() {
    const isBlocked = Radio.channel('blacklist').request(
      'isBlocked',
      this.userId,
    );
    if (isBlocked) {
      // Radio.channel('blacklist').request('unblock', this.userId);
      this.getRegion('userinfo').render();
    } else {
      // Radio.channel('blacklist').request('block', this.userId);
      this.getRegion('userinfo').render();
    }
  },
  requestPong() {
    console.log('아직 미구현!');
  },
  guildInvite() {
    console.log('guild');
  },
  dm() {
    console.log('dm');
  },
});

export default UserProfileModalView;
