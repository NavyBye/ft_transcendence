import Radio from 'backbone.radio';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/UserInfoView.html';

const UserInfoView = common.View.extend({
  template,
  onInitialize() {},
  onRender() {
    const isBlocked = Radio.channel('blacklist').request(
      'isBlocked',
      this.model.get('id'),
    );
    if (isBlocked) {
      $('#block-button').html('unblock');
    }
    $('#add-friend-button').html('Add Friend');
    $('#guild-invite-button').html('길드초대');
  },
});

export default UserInfoView;
