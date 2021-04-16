import Backbone from 'backbone';
import Radio from 'backbone.radio';
import view from './views';

const Router = Backbone.Router.extend({
  routes: {
    '': 'home',
    home: 'home',
    login: 'login',
  },
  initialize() {
    const channel = Radio.channel('route');
    const router = this;

    /* register router event handler */
    channel.on('route', function route(target) {
      router.navigate(target, { trigger: true });
    });
  },
  home() {
    const rootView = Radio.channel('app').request('rootView');
    rootView.show('content', new view.MainView());
  },
  login() {
    const rootView = Radio.channel('app').request('rootView');
    rootView.show('content', new view.LoginView());
  },
});

export default Router;
