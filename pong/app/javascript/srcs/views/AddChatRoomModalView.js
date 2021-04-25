import $ from 'jquery/src/jquery';
import common from '../common';

/* when to destroy? */
const AddChatRoomModalView = common.View.extend({
  el: '#add-chatroom-modal',
  events: {
    'click .create-button': 'createChatRoom',
    'click .close-button': 'close',
    'click #is-private': 'togglePassword',
  },
  onInitialize() {
    $(this.el).modal('show');
    $('#is-private').prop('checked', false);
    $('#room-password').prop('disabled', true);
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
    console.log('toggling...');
    const current = $('#room-password').prop('disabled');
    $('#room-password').prop('disabled', !current);
    console.log(`result = ${$('#room-password').prop('disabled')}`);
  },
});

export default AddChatRoomModalView;
