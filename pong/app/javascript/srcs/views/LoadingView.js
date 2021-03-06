import { Mutex } from 'async-mutex';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/LoadingView.html';
import auth from '../utils/auth';

const LoadingView = common.View.extend({
  el: '#content',
  template,
  onDestroy() {
    /* should disconnect from wait queue when going to another page */
    /* TODO: what to do not going to another page, just closing browser? */

    const mutex = new Mutex();
    mutex.acquire().then(function request(release) {
      $.ajax({
        type: 'DELETE',
        url: '/api/games/cancel',
        headers: auth.getTokenHeader(),
        success() {
          release();
        },
        error() {
          release();
        },
      });
    });
  },
  onRender() {},
});

export default LoadingView;
