import view from '.';
import common from '../common';
import template from '../templates/root.html';

const RootView = common.View.extend({
  el: '#root',
  template,
  onRender() {
    this.addRegion('content', '.content');
    this.show('content', new view.MainView());
  },
});

export default RootView;
