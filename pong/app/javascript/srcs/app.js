/* eslint-disable no-new */
/* eslint-disable no-unused-vars */
/* eslint-disable no-param-reassign */
/* eslint-disable no-unneeded-ternary */
/* eslint-disable camelcase */
import $ from 'jquery/src/jquery';
import Backbone from 'backbone';
import Radio from 'backbone.radio';
import { Mutex } from 'async-mutex';
import view from './views';
import Router from './router';
import auth from './utils/auth';
import ErrorModalView from './views/ErrorModalView';
import collection from './collections';
import model from './models';
import consumer from '../channels/consumer';
import OkModalView from './views/OkModalView';
import RequestPongMatchModalView from './views/RequestPongMatchModalView';

const app = {
  start() {
    app.initErrorHandler();
    $(document).ajaxError(function error(_event, res, _settings, _exception) {
      if (res.status / 100 !== 2) {
        if (res.responseText) {
          Radio.channel('error').request('trigger', res.responseText);
        } else {
          Radio.channel('error').request('trigger', res);
        }
      }
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
          consumer.disconnect();
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
          if (app.user.get('is_banned')) {
            Radio.channel('route').trigger('route', 'banned');
          }
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
    ])
      .catch(function noop() {})
      .finally(function then() {
        /* reply rootView */
        app.rootView = new view.RootView();
        Radio.channel('app').reply('rootView', function getRootView() {
          return app.rootView;
        });
        app.rootView.render();
        app.router = new Router();

        /* Do not subscribe if not logged in, it will subscribe in app.login reply */
        if (app.user) {
          app.initBlacklist();
          app.initFriendlist();
          app.initSignalHandler();
        }
      });

    Radio.channel('app').reply('subscribe', function login() {
      app.initBlacklist();
      app.initFriendlist();
      app.initSignalHandler();
    });

    /*
      Used to pass from signal to router....
       Sorry, but this is less dirty way to implement it
    */
    Radio.channel('game').reply('get', function get() {
      return app.gameData;
    });
    Radio.channel('game').reply('set', function set(data) {
      app.gameData = data;
    });
  },
  initSignalHandler() {
    const login = Radio.channel('login').request('get');
    this.signalChannel = consumer.subscriptions.create(
      {
        channel: 'SignalChannel',
        id: login.get('id'),
      },
      {
        connected() {},
        disconnected() {},
        received(data) {
          if (data && data.type) {
            Radio.channel('signal').request(data.type, data);
          }
        },
      },
    );

    /* redirect fetch radio to actual handler */
    Radio.channel('signal').reply('fetch', function fetch(data) {
      if (data && data.element) {
        Radio.channel(data.element).request(data.type, data);
      }
    });

    /* redirect notify radio */
    Radio.channel('signal').reply('notify', function notification(data) {
      if (data && data.element) {
        Radio.channel(data.element).request(data.type, data);
      }
    });

    /* game connect signal (when match making was successful) */
    Radio.channel('signal').reply('connect', function gameConnect(data) {
      const mutex = new Mutex();

      mutex.acquire().then(function foo(release) {
        Radio.channel('game').request('set', data);
        Radio.channel('route').trigger('route', `play?game_id=${data.game_id}`);
        release();
      });
    });

    /* game match making refused */
    Radio.channel('signal').reply('refuse', function requestRefused(data) {
      new OkModalView().show(
        'Match Request Refused',
        'Your game request was refused.',
      );
      Radio.channel('route').trigger('route', 'home');
    });

    /* someone requested pong match to me */
    Radio.channel('signal').reply('request', function requestRefused(data) {
      new RequestPongMatchModalView({
        user: data.user,
        game: data.game,
      });
    });
  },
  initErrorHandler() {
    Radio.channel('error').reply('trigger', function handler(json) {
      const parsed = typeof json === 'string' ? JSON.parse(json) : json;
      if (parsed.type === 'message') {
        new ErrorModalView().show('Error', parsed.message);
      } else if (parsed.type === 'redirect') {
        Radio.channel('route').trigger('route', parsed.target);
      } else {
        new ErrorModalView().show('Unknown Error', json);
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
    /* subscribe my friend channel */
    const login = Radio.channel('login').request('get');
    this.friendConnection = consumer.subscriptions.create(
      {
        channel: 'FriendChannel',
        id: login.get('id'),
      },
      {
        connected() {},
        disconnected() {},
        received() {},
      },
    );

    /* make friend list */
    app.friendlist = new collection.FriendCollection();
    app.friendlist.fetch({ async: false });
    Radio.channel('friendlist').reply('isFriend', function friendlist(userId) {
      const found = app.friendlist.findWhere({
        id: userId,
      });
      return found ? true : false;
    });

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
        success() {
          Radio.channel('friendView').trigger('refresh');
        },
      });
    });
  },
};

export default app;
