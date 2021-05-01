import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/MyPageView.html';
import ErrorModalView from './ErrorModalView';
import OkModalView from './OkModalView';

const MyPageView = common.View.extend({
  el: '#content',
  template,
  events: {
    'click .submit-button': 'submit',
  },
  submit(event) {
    event.preventDefault();
    const nickname = $('#my-page input[name=nickname]').val();
    const enable2FA = $('#my-page input[name=2fa]').is(':checked');
    const file = $('#my-page #upload-image').get(0).files[0];

    if (file) {
      const formData = new FormData();
      formData.append('file', file);
      /* image upload */
      $.ajax({
        type: 'POST',
        url: /* I don't know what url is */ '',
        data: formData,
        enctype: 'multipart/form-data',
        processData: false,
        contentType: false,
        error(res) {
          new ErrorModalView().show(
            'Error while uploading image',
            res.responseText,
          );
        },
      });
    }

    this.model.set('nickname', nickname);
    this.model.set('is_email_auth', enable2FA);
    this.model.save({
      /* FIXME: callback is not working */
      success() {
        new OkModalView().show('Success', 'Successfully saved user data');
      },
      error(res) {
        new ErrorModalView().show(
          'Error while saving user data',
          res.responseText,
        );
      },
    });
    this.model.fetch();
  },
});

export default MyPageView;
