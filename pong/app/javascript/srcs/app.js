import Backbone from 'backbone';
import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import view from './views';
import Router from './router';
import auth from './utils/auth';
import ErrorModalView from './views/ErrorModalView';

const app = {
  start() {
    $.ajaxSetup({
      headers: {
        X_CSRF_TOKEN: auth.getTokenValue(),
      },
      error: function error(res) {
        new ErrorModalView().show('Error', res.responseText);
      },
    });

    Radio.channel('app').reply('logout', function logout() {
      $.ajax({
        type: 'DELETE',
        url: '/sign_out',
        success(res) {
          app.user = null;
          $('meta[name="csrf-param"]').attr('content', res.csrf_param);
          $('meta[name="csrf-token"]').attr('content', res.csrf_token);
          Radio.channel('route').trigger('route', 'login');
        },
      });
    });

    if (!Backbone.History.started) Backbone.history.start();

    /* reply user */
    Radio.channel('app').reply('login', function getUser() {
      return app.user;
    });

    app.rootView = new view.RootView();
    /* reply rootView */
    Radio.channel('app').reply('rootView', function getRootView() {
      return app.rootView;
    });
    app.rootView.render();

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
      Backbone.history.loadUrl(Backbone.history.fragment);
      // app.router.navigate(Backbone.history.fragment, { trigger: true });
      // Radio.channel('route').trigger('route', Backbone.history.fragment);
    });
  },
};

export default app;
