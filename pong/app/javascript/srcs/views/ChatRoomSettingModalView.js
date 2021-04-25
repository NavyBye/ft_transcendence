import $ from 'jquery/src/jquery';
import common from '../common';

const ChatRoomSettingModalView = common.View.extend({
  el: '#chatroom-setting-modal',
  events: {
    'click .create-button': 'createChatRoom',
    'click #chatroom-setting-is-private': 'togglePassword',
  },
  onInitialize() {
    $(this.el).modal('show');
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
      url: '/api/chatrooms',
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
