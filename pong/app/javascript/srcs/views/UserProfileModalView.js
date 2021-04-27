import Radio from 'backbone.radio';
import $ from 'jquery/src/jquery';
import common from '../common';
import UserInfoView from './UserInfoView';
import UserHistoryCollectionView from './UserHistoryCollectionView';
import model from '../models';

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
    const user = new model.UserModel(this.userId);
    const self = this;
    user.fetch({
      success() {
        self.show('userinfo', new UserInfoView({ model: user }));
        self.show('userhistory', new UserHistoryCollectionView(self.userId));
      },
    });
    $(this.el).modal('show');
    const view = this;
    $(this.el).on('hide.bs.modal', function destroy() {
      view.destroy();
    });
  },
  onRender() {},
  onDestroy() {},
  addFriend() {
    console.log('add_friend btn');
    const login = Radio.channel('app').request('login');
    $.ajax({
      type: 'POST',
      url: `/api/users/${login.id}/friends`,
      data: { follow_id: this.userId },
    });
  },
  block() {
    console.log('block btn');
    const login = Radio.channel('app').request('login');
    $.ajax({
      type: 'POST',
      url: `/api/user/${login.id}/block`,
      data: { user_id: this.userId },
    });
  },
  requestPong() {
    console.log('rpm');
  },
  guildInvite() {
    console.log('guild');
  },
  dm() {
    console.log('dm');
  },
});

export default UserProfileModalView;
