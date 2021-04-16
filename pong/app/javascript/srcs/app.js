import Backbone from 'backbone';
import Radio from 'backbone.radio';
import view from './views';
import Router from './router';

const app = {
  start() {
    /* Now you can get rootView using channel.request('rootView') */
    const channel = Radio.channel('app');
    this.rootView = new view.RootView();
    this.rootView.render();
    const root = this.rootView;
    channel.reply('rootView', function getRootView() {
      return root;
    });

    this.router = new Router();

    if (Backbone.History.started) return;
    Backbone.history.start();
  },
};

export default app;
