import $ from 'jquery/src/jquery';
import common from '../common';

const OkModalView = common.View.extend({
  el: '#ok-modal-view',
  show(title, body) {
    $(this.el).modal('show');
    $('#ok-modal-view .modal-title').text(title);
    $('#ok-modal-view .modal-body').text(body);
  },
});

export default OkModalView;
