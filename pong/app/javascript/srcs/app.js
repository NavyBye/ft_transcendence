import Backbone from 'backbone';
import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import view from './views';
import Router from './router';

const app = {
  start() {
    Radio.channel('app').reply('logout', function logout() {
      app.user = null;
    });

    /* reply user */
    Radio.channel('app').reply('login', function getUser() {
      return app.user;
    });

    Promise.all([
      /* get userinfo */
      $.ajax({
        type: 'GET',
        url: '/api/users/me',
        success(data) {
          app.user = data;
        },
      }),
    ]).finally(function then() {
      app.router = new Router();
      /* reply rootView */
      app.rootView = new view.RootView();
      Radio.channel('app').reply('rootView', function getRootView() {
        return app.rootView;
      });
      app.rootView.render();
      if (!Backbone.History.started) Backbone.history.start();
      app.router.navigate(Backbone.history.fragment, { trigger: true });
    });
  },
};

export default app;
