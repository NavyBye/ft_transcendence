import $ from 'jquery/src/jquery';
import common from '../common';
import auth from '../utils/auth';

/* when to destroy? */
const AddChatRoomModalView = common.View.extend({
  el: '#add-chatroom-modal',
  events: {
    'click .create-button': 'createChatRoom',
    'click #add-chatroom-is-private': 'togglePassword',
  },
  onInitialize() {
    $(this.el).modal('show');
    $('#add-chatroom-is-private').prop('checked', false);
    $('#add-chatroom-password').prop('disabled', true);

    const view = this;
    $(this.el).on('hide.bs.modal', function destroy() {
      view.destroy();
    });
  },
  onDestroy() {
    $('#add-chatroom-modal input').val('');
  },
  createChatRoom() {
    const data = {};
    data.name = $('#add-chatroom-name').val();
    const isPrivate = $('#add-chatroom-is-private').is(':checked');
    if (isPrivate) data.password = $('#add-chatroom-password').val();

    $.ajax({
      type: 'POST',
      url: '/api/chatrooms',
      headers: auth.getTokenHeader(),
      data,
    });

    $(this.el).modal('hide');
  },
  togglePassword() {
    const current = $('#add-chatroom-password').prop('disabled');
    $('#add-chatroom-password').prop('disabled', !current);
  },
});

export default AddChatRoomModalView;
