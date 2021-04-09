import Backbone from 'backbone';
import view from './views';

const app = {
  start() {
    if (Backbone.History.started) return;
    Backbone.history.start();
    this.rootView = new view.RootView();
    this.rootView.render();
  },
};

export default app;
