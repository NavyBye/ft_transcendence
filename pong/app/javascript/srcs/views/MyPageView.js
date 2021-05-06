/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/MyPageView.html';
import ErrorModalView from './ErrorModalView';
import OkModalView from './OkModalView';
import auth from '../utils/auth';

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

    this.model.set('nickname', nickname);
    this.model.set('is_email_auth', enable2FA);

    const formData = new FormData();
    if (file) {
      formData.append('image', file);
      /* image preview */
      const reader = new FileReader();
      reader.onload = function onload(e) {
        $('#my-page img').attr('src', e.target.result);
      };
      reader.readAsDataURL(file);
    }

    formData.append('nickname', nickname);
    formData.append('is_email_auth', enable2FA);

    /* upload */
    const self = this;
    $.ajax({
      type: 'PUT',
      url: `/api/users/${this.model.get('id')}`,
      headers: auth.getTokenHeader(),
      data: formData,
      enctype: 'multipart/form-data',
      processData: false,
      contentType: false,
      success() {
        self.model.fetch();
        new OkModalView().show('Success', 'Successfully saved user data');
      },
      error(res) {
        new ErrorModalView().show(
          'Error while saving user data',
          res.responseText,
        );
      },
    });
  },
});

export default MyPageView;
