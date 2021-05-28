import Radio from 'backbone.radio';
import $ from 'jquery/src/jquery';
import common from '../common';
import UserInfoView from './UserInfoView';
import UserHistoryCollectionView from './UserHistoryCollectionView';
import model from '../models';
import auth from '../utils/auth';
import OkModalView from './OkModalView';

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
    const isFriend = Radio.channel('friendlist').request(
      'isFriend',
      this.userId,
    );

    if (isFriend) {
      Radio.channel('friendlist').request('unfollow', this.userId);
    } else {
      Radio.channel('friendlist').request('follow', this.userId);
    }
    $(this.el).modal('hide');
  },
  block() {
    const isBlocked = Radio.channel('blacklist').request(
      'isBlocked',
      this.userId,
    );

    if (isBlocked) {
      Radio.channel('blacklist').request('unblock', this.userId);
    } else {
      Radio.channel('blacklist').request('block', this.userId);
    }

    this.getRegion('userinfo').getView().render();
    Radio.channel('chat-collection').request('fetch');
    $(this.el).modal('hide');
  },
  requestPong() {},
  guildInvite() {
    const self = this;
    $.ajax({
      type: 'POST',
      url: `/api/users/${this.userId}/invites`,
      headers: auth.getTokenHeader(),
      success() {
        $(self.el).modal('hide');
        new OkModalView().show('Success', 'Successfully invite');
      },
      error(res) {
        $(self.el).modal('hide');
        Radio.channel('error').request('trigger', res.responseText);
      },
    });
  },
  dm() {
    /* create DM if not exists */
    $.ajax({
      type: 'POST',
      url: '/api/dmrooms',
      headers: auth.getTokenHeader(),
      data: { user_id: this.userId },
      success(created) {
        Radio.channel('side').request('changeTab', 'dm-tab');
        setTimeout(function enterDmRoom() {
          Radio.channel('side').trigger('enter-dmroom', created.id);
        }, 1);
      },
    });
    $(this.el).modal('hide');
  },
});

export default UserProfileModalView;
