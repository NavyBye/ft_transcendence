/* eslint-disable no-new */
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/ChatRoomUserView.html';
import UserProfileModalView from './UserProfileModalView';

const ChatRoomUserView = common.View.extend({
  template,
  events: {
    click: 'showUserProfile',
  },
  showUserProfile() {
    const id = this.model.get('id');
    $('#chatRoomUserModal').modal('hide');
    new UserProfileModalView(id);
  },
  onRender() {
    if (this.model.get('role') !== 'user') {
      this.$el.css('display', 'none');
    }
  },
});

export default ChatRoomUserView;
