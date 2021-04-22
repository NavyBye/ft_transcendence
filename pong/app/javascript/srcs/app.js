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
      Backbone.history.loadUrl(Backbone.history.fragment);
      app.router.navigate(Backbone.history.fragment, { trigger: true });
    });
  },
};

export default app;
