import common from '../common';
import template from '../templates/MainView.html';
import NavView from './NavView';
import SideView from './SideView';

const MainView = common.View.extend({
  template,
  onInitialize() {
    this.addRegion('nav', '#nav');
    this.addRegion('content', '#content');
    this.addRegion('side', '#side');
  },
  onRender() {
    this.show('nav', new NavView());
    this.show('side', new SideView());
  },
  onDestroy() {
    this.getRegion('nav').getView().destroy();
    this.getRegion('content').getView().destroy();
    this.getRegion('side').getView().destroy();
  },
});

export default MainView;
