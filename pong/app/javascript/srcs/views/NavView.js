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

  if (href === 'toggle') {
    if (this.toggle) {
      $('#toggle').remove();
    } else {
      (function toggle() {
        const css =
          'html {-webkit-filter: invert(100%);' +
          '-moz-filter: invert(100%);' +
          '-o-filter: invert(100%);' +
          '-ms-filter: invert(100%); }';
        const head = document.getElementsByTagName('head')[0];
        const style = document.createElement('style');
        style.setAttribute('id', 'toggle');
        if (!window.counter) {
          window.counter = 1;
        } else {
          window.counter++;
          if (window.counter % 2 === 0) {
            const css =
              'html {-webkit-filter: invert(0%); -moz-filter: invert(0%); -o-filter: invert(0%); -ms-filter: invert(0%); }';
          }
        }
        style.type = 'text/css';
        if (style.styleSheet) {
          style.styleSheet.cssText = css;
        } else {
          style.appendChild(document.createTextNode(css));
        }
        head.appendChild(style);
      })();
    }
    this.toggle = !this.toggle;
  } else {
    Radio.channel('route').trigger('route', href);
  }
}

function logout(event) {
  event.preventDefault();
  Radio.channel('app').request('logout');
}

const NavView = common.View.extend({
  el: '#nav',
  events: { 'click #logout': logout, 'click a:not(#logout)': link },
  template,
  onRender() {
    this.toggle = false;
  },
});

export default NavView;
