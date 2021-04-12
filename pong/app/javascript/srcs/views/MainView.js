import view from '.';
import common from '../common';
import template from '../templates/main.html';

const MainView = common.View.extend({
  template,
  onRender() {
    this.addRegion('nav', '#nav');
    this.addRegion('content', '#content');
    this.addRegion('side', '#side');

    this.show('nav', new view.NavView());
  },
});

export default MainView;
