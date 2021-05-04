import $ from 'jquery/src/jquery';
import common from '../common';
import auth from '../utils/auth';
import ErrorModalView from './ErrorModalView';

const InputPasswordModalView = common.View.extend({
  el: '#input-password-modal',
  events: {
    'click .enter-button': 'enterRoom',
  },
  onInitialize() {
    $(this.el).modal('show');

    const view = this;
    $(this.el).on('hide.bs.modal', function destroy() {
      view.destroy();
    });
  },
  onDestroy() {
    $('#input-password-modal input').val('');
  },
  enterRoom() {
    const view = this;
    const data = {};
    data.password = $('#chatroom-password').val();
    $.ajax({
      type: 'POST',
      url: `/api/chatrooms/${view.model.get('id')}/members`,
      headers: auth.getTokenHeader(),
      data,
      success() {
        view.model.set('joined', true);
      },
      error(res) {
        new ErrorModalView().show('Error', res.responseText);
      },
    });
    $(this.el).modal('hide');
  },
});

export default InputPasswordModalView;
