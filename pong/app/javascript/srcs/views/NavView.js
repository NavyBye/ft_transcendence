/* eslint-disable no-shadow */
/* eslint-disable no-unused-vars */
/* eslint-disable no-plusplus */
import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/NavView.html';

function link(event) {
  const href = event.target.getAttribute('href');
  event.preventDefault();
  Radio.channel('route').trigger('route', href);
}

function logout(event) {
  event.preventDefault();
  Radio.channel('app').request('logout');
}

const NavView = common.View.extend({
  el: '#nav',
  events: { 'click #logout': logout, 'click a:not(#logout)': link },
  template,
  onRender() {},
});

export default NavView;
