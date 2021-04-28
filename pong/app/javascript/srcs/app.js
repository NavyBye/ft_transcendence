/* eslint-disable no-unneeded-ternary */
/* eslint-disable camelcase */
import Backbone from 'backbone';
import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import view from './views';
import Router from './router';
import auth from './utils/auth';
import ErrorModalView from './views/ErrorModalView';
import collection from './collections';

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
      app.router.navigate(Backbone.history.fragment, { trigger: true });

      /* only when logged in */
      if (app.user) {
        /* init routines after login is finished */
        app.initBlacklist();
        app.initChatRoomList();
      }
    });
  },
  initChatRoomList() {
    app.chatRoomList = new collection.ChatRoomCollection();
    app.chatRoomList.url = function url() {
      return '/api/my/chatrooms';
    };

    app.chatRoomList.fetch({ async: false });
    Radio.channel('chatroom').reply('isJoined', function isJoined(chatRoomId) {
      const found = app.chatRoomList.findWhere({ id: chatRoomId });
      return found ? true : false;
    });
  },
  initBlacklist() {
    /* reply blacklist */
    app.blacklist = new collection.BlockCollection();
    app.blacklist.fetch();
    Radio.channel('blacklist').reply(
      'filter',
      function blacklist(model, filterBy, replaceKey) {
        if (app.blacklist.findWhere({ block_user_id: model.get(filterBy) })) {
          model.set(replaceKey, 'blocked');
          return model;
        }
        return model;
      },
    );

    Radio.channel('blacklist').reply(
      'isBlocked',
      function blacklist(model, userIdKey) {
        const found = app.blacklist.findWhere({
          blocked_user_id: model.get(userIdKey),
        });
        return found ? true : false;
      },
    );

    Radio.channel('blacklist').reply('block', function block(block_user_id) {
      app.blacklist.create({ block_user_id, user_id: app.user.id });
    });

    Radio.channel('blacklist').reply(
      'unblock',
      function unblock(block_user_id) {
        const blocked = app.blacklist.findWhere({ block_user_id });
        app.blacklist.remove(blocked);
        blocked.remove();
      },
    );
  },
};

export default app;
