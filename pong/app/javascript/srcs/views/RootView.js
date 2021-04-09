import common from '../common';
import template from '../templates/root.html';

const RootView = common.View.extend({
  el: '#root',
  template,
});

export default RootView;
