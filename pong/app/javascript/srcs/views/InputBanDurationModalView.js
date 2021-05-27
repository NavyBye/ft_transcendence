import { Radio } from 'backbone';
import $ from 'jquery/src/jquery';
import common from '../common';
import auth from '../utils/auth';
import OkModalView from './OkModalView';

const InputBanDurationModalView = common.View.extend({
  el: '#input-ban-duration-modal',
  events: {
    'click .ban-button': 'ban',
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
    $('#input-ban-duration-modal input').val('');
  },
  ban() {
    const chatRoomId = Radio.channel('chat-collection').request('getId');
    const data = {};
    data.duration = $('#ban-duration').val();
    $.ajax({
      type: 'POST',
      url: `/api/chatrooms/${chatRoomId}/members/${this.userId}/ban`,
      headers: auth.getTokenHeader(),
      data,
      success() {
        new OkModalView().show('Title', 'Successfully banned!');
      },
    });
    $(this.el).modal('hide');
  },
});

export default InputBanDurationModalView;
