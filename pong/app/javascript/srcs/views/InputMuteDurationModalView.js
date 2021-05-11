/* eslint-disable no-console */
import { Radio } from 'backbone';
import $ from 'jquery/src/jquery';
import common from '../common';
import auth from '../utils/auth';
import OkModalView from './OkModalView';

const InputMuteDurationModalView = common.View.extend({
  el: '#input-mute-duration-modal',
  events: {
    'click .mute-button': 'mute',
  },
  onInitialize(obj) {
    this.userId = obj;
    $(this.el).modal('show');

    const view = this;
    $(this.el).on('hide.bs.modal', function destroy() {
      view.destroy();
    });
  },
  onDestroy() {
    $('#input-mute-duration-modal input').val('');
  },
  mute() {
    const chatRoomId = Radio.channel('chat-collection').request('getId');
    const data = {};
    data.duration = $('#mute-duration').val();
    $.ajax({
      type: 'POST',
      url: `/api/chatrooms/${chatRoomId}/members/${this.userId}/mute`,
      headers: auth.getTokenHeader(),
      data,
      success() {
        new OkModalView().show('Title', 'Successfully muted!');
      },
      error(res) {
        Radio.channel('error').request('trigger', res.responseText);
      },
    });
    $(this.el).modal('hide');
  },
});

export default InputMuteDurationModalView;
