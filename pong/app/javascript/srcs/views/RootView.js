import common from '../common';
import template from '../templates/RootView.html';
import MainView from './MainView';

const RootView = common.View.extend({
  el: '#root',
  template,
  onRender() {
    this.addRegion('content', '.content');
    this.show('content', new MainView());
  },
});

export default RootView;
