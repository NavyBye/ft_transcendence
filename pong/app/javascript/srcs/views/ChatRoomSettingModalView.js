import $ from 'jquery/src/jquery';
import common from '../common';
import auth from '../utils/auth';

const ChatRoomSettingModalView = common.View.extend({
  el: '#chatroom-setting-modal',
  events: {
    'click .create-button': 'createChatRoom',
    'click #chatroom-setting-is-private': 'togglePassword',
  },
  onInitialize(obj) {
    $(this.el).modal('show');
    if (obj && obj.chatRoomId) this.chatRoomId = obj.chatRoomId;
    $('#chatroom-setting-is-private').prop('checked', false);
    $('#chatroom-setting-password').prop('disabled', true);

    const view = this;
    $(this.el).on('hide.bs.modal', function destroy() {
      view.destroy();
    });
  },
  onDestroy() {
    $('#chatroom-setting-modal input').val('');
  },
  createChatRoom() {
    const data = {};
    data.name = $('#chatroom-setting-name').val();
    const isPrivate = $('#chatroom-setting-is-private').is(':checked');
    if (isPrivate) data.password = $('#chatroom-setting-password').val();

    $.ajax({
      type: 'PUT',
      url: `/api/chatrooms/${this.chatRoomId}`,
      headers: auth.getTokenHeader(),
      data,
    });
    $(this.el).modal('hide');
  },

  togglePassword() {
    const current = $('#chatroom-setting-password').prop('disabled');
    $('#chatroom-setting-password').prop('disabled', !current);
  },
});

export default ChatRoomSettingModalView;
