import $ from 'jquery/src/jquery';
import common from '../common';

/* when to destroy? */
const AddChatRoomModalView = common.View.extend({
  el: '#add-chatroom-modal',
  events: {
    'click .create-button': 'createChatRoom',
    'click .close-button': 'createChatRoom',
    'click #is-private': 'togglePassword',
  },
  onInitialize() {
    $(this.el).modal('show');
  },
  onDestroy() {
    $('#add-chatroom-modal input').val('');
    $(this.el).modal('hide');
  },
  createChatRoom() {
    const data = {};
    data.name = $('#room-name').val();
    const isPrivate = $('#is-private').is(':checked');
    if (isPrivate) data.password = $('#room-password').val();

    $.ajax({
      type: 'POST',
      url: '/api/chatrooms',
      data,
    });

    this.destroy();
  },
  close() {
    this.destroy();
  },
  togglePassword() {
    const current = $('#room-password').prop('disabled');
    $('#room-password').prop('disabled', !current);
  },
});

export default AddChatRoomModalView;
