import common from '../common';
import template from '../templates/MainView.html';
import NavView from './NavView';
import SideView from './SideView';

const MainView = common.View.extend({
  template,
  onRender() {
    this.addRegion('nav', '#nav');
    this.addRegion('content', '#content');
    this.addRegion('side', '#side');

    this.show('nav', new NavView());
    this.show('side', new SideView());
  },
});

export default MainView;
