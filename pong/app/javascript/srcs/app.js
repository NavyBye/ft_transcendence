/* eslint-disable no-unneeded-ternary */
/* eslint-disable camelcase */
import $ from 'jquery/src/jquery';
import Radio from 'backbone.radio';
import view from './views';
import Router from './router';
import auth from './utils/auth';
import ErrorModalView from './views/ErrorModalView';
import collection from './collections';
import model from './models';

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
    Radio.channel('login').reply('get', function getUser() {
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
          app.user = new model.UserModel(data);
        },
      }),
    ]).finally(function then() {
      /* reply rootView */
      app.rootView = new view.RootView();
      Radio.channel('app').reply('rootView', function getRootView() {
        return app.rootView;
      });
      app.rootView.render();
      app.router = new Router();
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
    app.blacklist.fetch({ async: false });
    Radio.channel('blacklist').reply(
      'filter',
      function blacklist(m, filterBy, replaceKey) {
        if (app.blacklist.findWhere({ block_user_id: m.get(filterBy) })) {
          m.set(replaceKey, 'blocked');
          return m;
        }
        return m;
      },
    );

    Radio.channel('blacklist').reply('isBlocked', function blacklist(userId) {
      const found = app.blacklist.findWhere({
        id: userId,
      });
      return found ? true : false;
    });

    Radio.channel('blacklist').reply('block', function block(blocked_user_id) {
      app.blacklist.create({ blocked_user_id, user_id: app.user.get('id') });
    });

    Radio.channel('blacklist').reply('unblock', function unblock(id) {
      const blocked = app.blacklist.findWhere({ id });
      app.blacklist.remove(blocked);
      $.ajax({
        type: 'DELETE',
        url: `/api/users/${app.user.get('id')}/blocks/${id}`,
      });
    });
  },
};

export default app;
