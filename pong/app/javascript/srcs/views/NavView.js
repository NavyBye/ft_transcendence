import Radio from 'backbone.radio';
import common from '../common';
import template from '../templates/nav.html';

function link(event) {
  const href = event.target.getAttribute('href');
  const channel = Radio.channel('route');

  event.preventDefault();
  channel.trigger('route', href);
}

const NavView = common.View.extend({
  el: '#nav',
  events: { 'click a': link },
  template,
});

export default NavView;
