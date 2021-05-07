/* eslint-disable no-param-reassign */
/* eslint-disable no-unneeded-ternary */
/* eslint-disable camelcase */
import $ from 'jquery/src/jquery';
import Backbone from 'backbone';
import Radio from 'backbone.radio';
import view from './views';
import Router from './router';
import auth from './utils/auth';
import ErrorModalView from './views/ErrorModalView';
import collection from './collections';
import model from './models';

const app = {
  start() {
    app.initErrorHandler();
    $.ajaxSetup({
      error: function error(res) {
        Radio.channel('error').request('trigger', res.responseText);
      },
    });

    const callback = Backbone.sync;
    Backbone.sync = function sync(method, model_, options) {
      options.headers = auth.getTokenHeader();
      callback(method, model_, options);
    };

    Radio.channel('app').reply('logout', function logout() {
      $.ajax({
        type: 'DELETE',
        url: '/sign_out',
        headers: auth.getTokenHeader(),
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

    Radio.channel('login').reply('fetch', function fetcg() {
      $.ajax({
        type: 'GET',
        url: '/api/users/me',
        headers: auth.getTokenHeader(),
        success(data) {
          app.user = new model.UserModel(data);
        },
        async: false,
      });
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
        headers: auth.getTokenHeader(),
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
        app.initFriendlist();
      }
    });
  },
  initErrorHandler() {
    Radio.channel('error').reply('trigger', function handler(json) {
      if (typeof json === 'string') json = JSON.parse(json);

      if (json.type === 'message') {
        new ErrorModalView().show('Error', json.message);
      } else if (json.type === 'redirect') {
        Radio.channel('route').trigger('route', json.target);
      }
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

    Radio.channel('blacklist').reply('block', function block(userId) {
      const login = Radio.channel('login').request('get');
      $.ajax({
        type: 'POST',
        url: `/api/users/${login.get('id')}/blocks`,
        headers: auth.getTokenHeader(),
        data: { id: userId },
        success() {
          const blockedUser = new model.UserModel({ id: userId });
          blockedUser.fetch({ async: false });
          app.blacklist.add(blockedUser);
        },
      });
    });

    Radio.channel('blacklist').reply('unblock', function unblock(id) {
      const blocked = app.blacklist.findWhere({ id });
      app.blacklist.remove(blocked);
      $.ajax({
        type: 'DELETE',
        url: `/api/users/${app.user.get('id')}/blocks/${id}`,
        headers: auth.getTokenHeader(),
        success() {
          app.blacklist.fetch();
        },
      });
    });
  },
  initFriendlist() {
    app.friendlist = new collection.FriendCollection();
    app.friendlist.fetch({ async: false });
    Radio.channel('friendlist').reply('isFriend', function friendlist(userId) {
      const found = app.friendlist.findWhere({
        id: userId,
      });
      return found ? true : false;
    });

    Radio.channel('friendlist').reply(
      'follow',
      function follow(follow_user_id) {
        app.friendlist.create({ follow_user_id, user_id: app.user.get('id') });
      },
    );

    Radio.channel('friendlist').reply('follow', function follow(id) {
      $.ajax({
        type: 'POST',
        url: `/api/users/${app.user.get('id')}/friends`,
        headers: auth.getTokenHeader(),
        data: { id },
        success() {
          app.friendlist.fetch();
        },
      });
    });

    Radio.channel('friendlist').reply('unfollow', function unfollow(id) {
      const followed = app.friendlist.findWhere({ id });
      app.friendlist.remove(followed);
      $.ajax({
        type: 'DELETE',
        url: `/api/users/${app.user.get('id')}/friends/${id}`,
        headers: auth.getTokenHeader(),
      });
    });
  },
};

export default app;
