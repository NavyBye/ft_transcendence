import Backbone from 'backbone';
import Radio from 'backbone.radio';
import view from './views';

const Router = Backbone.Router.extend({
  routes: {
    '': 'home',
    home: 'home',
    login: 'login',
    ranking: 'rankPage',
    mypage: 'myPage',
  },
  initialize() {
    const channel = Radio.channel('route');
    const router = this;

    /* register router event handler */
    channel.on('route', function route(target) {
      router.navigate(target, { trigger: true });
    });

    channel.on('refresh', function refresh() {
      Backbone.history.loadUrl(Backbone.history.fragment);
    });

    if (!Backbone.History.started) {
      Backbone.history.start();
    }
  },
  home() {
    const rootView = Radio.channel('app').request('rootView');
    const login = Radio.channel('login').request('get');
    if (!login) {
      Radio.channel('route').trigger('route', 'login');
    } else {
      if (!rootView.getRegion('content').getView())
        rootView.show('content', new view.MainView());
      rootView
        .getRegion('content')
        .getView()
        .show('content', new view.HomeView());
    }
  },
  login() {
    const rootView = Radio.channel('app').request('rootView');
    const login = Radio.channel('login').request('get');
    if (login) {
      Radio.channel('route').trigger('route', 'home');
    } else {
      rootView.show('content', new view.LoginView());
    }
  },
  rankPage() {
    const rootView = Radio.channel('app').request('rootView');
    const login = Radio.channel('login').request('get');
    if (!login) {
      Radio.channel('route').trigger('route', 'login');
    } else {
      if (!rootView.getRegion('content').getView())
        rootView.show('content', new view.MainView());
      rootView
        .getRegion('content')
        .getView()
        .show('content', new view.RankPageView());
    }
  },
  myPage() {
    const rootView = Radio.channel('app').request('rootView');
    const login = Radio.channel('login').request('get');
    if (!login) {
      Radio.channel('route').trigger('route', 'login');
    } else {
      if (!rootView.getRegion('content').getView())
        rootView.show('content', new view.MainView());
      rootView
        .getRegion('content')
        .getView()
        .show('content', new view.MyPageView({ model: login }));
    }
  },
});

export default Router;
