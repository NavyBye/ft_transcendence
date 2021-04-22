import $ from 'jquery/src/jquery';
import common from '../common';

const ErrorModalView = common.View.extend({
  el: '#error-modal-view',
  show(title, body) {
    $(this.el).modal('show');
    $('#error-modal-view .modal-title').text(title);
    $('#error-modal-view .modal-body').text(body);
  },
});

export default ErrorModalView;
