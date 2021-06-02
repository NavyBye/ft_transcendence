/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import { Radio } from 'backbone';
import common from '../common';
import template from '../templates/MyPageView.html';
import OkModalView from './OkModalView';
import auth from '../utils/auth';

const MyPageView = common.View.extend({
  el: '#content',
  template,
  events: {
    'click .submit-button': 'submit',
    'change #upload-image': 'preview',
  },
  onInitialize() {
    this.reader = new FileReader();
    this.reader.onload = function onload(e) {
      $('#my-page img').attr('src', e.target.result);
    };
    this.formData = new FormData();
  },
  preview() {
    const file = $('#upload-image').get(0).files[0];
    if (file) {
      this.formData.append('image', file);
      /* image preview */
      this.reader.readAsDataURL(file);
    }
  },
  submit(event) {
    event.preventDefault();
    const nickname = $('#my-page input[name=nickname]').val();
    const enable2FA = $('#my-page input[name=2fa]').is(':checked');

    this.model.set('nickname', nickname);
    this.model.set('is_email_auth', enable2FA);

    this.formData.append('nickname', nickname);
    this.formData.append('is_email_auth', enable2FA);

    /* upload */
    const self = this;
    $.ajax({
      type: 'PUT',
      url: `/api/users/${this.model.get('id')}`,
      headers: auth.getTokenHeader(),
      data: self.formData,
      enctype: 'multipart/form-data',
      processData: false,
      contentType: false,
      success() {
        self.model.fetch();
        new OkModalView().show('Success', 'Successfully saved user data');
        Radio.channel('side').request('refresh');
      },
    });
  },
});

export default MyPageView;
