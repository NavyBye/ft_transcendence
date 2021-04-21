import Radio from 'backbone.radio';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/NavView.html';
import auth from '../utils/auth';

function link(event) {
  const href = event.target.getAttribute('href');

  event.preventDefault();
  Radio.channel('route').trigger('route', href);
}

function logout(event) {
  event.preventDefault();
  const data = {};
  data[auth.getTokenKey()] = auth.getTokenValue();
  $.ajax({
    type: 'DELETE',
    url: '/sign_out',
    data,
    success() {
      Radio.channel('app').request('logout');
      Radio.channel('route').trigger('route', 'login');
    },
  });
}

const NavView = common.View.extend({
  el: '#nav',
  events: { 'click #logout': logout, 'click a:not(#logout)': link },
  template,
});

export default NavView;
