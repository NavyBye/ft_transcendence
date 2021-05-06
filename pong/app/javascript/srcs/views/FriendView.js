import { Radio } from 'backbone';
import BootstrapMenu from 'bootstrap-menu';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/FriendView.html';
import auth from '../utils/auth';
import consumer from '../../channels/consumer';

const FriendView = common.View.extend({
  template,
  onInitialize() {
    const self = this;
    this.channel = consumer.subscriptions.create(
      {
        channel: 'FriendChannel',
        id: self.model.get('id'),
      },
      {
        connected() {},
        disconnected() {},
        received(data) {
          self.model.set({ status: JSON.parse(data.data).status });
          self.render();
        },
      },
    );
  },
  onRender() {
    const id = this.model.get('id');
    const login = Radio.channel('login').request('get');
    this.menu = new BootstrapMenu(this.el, {
      actions: [
        {
          name: 'Destroy',
          onClick() {
            $.ajax({
              type: 'DELETE',
              url: `/api/users/${login.get('id')}/friends/${id}`,
              headers: auth.getTokenHeader(),
            });
          },
          classNames: 'dropdown-item',
        },
      ],
    });
  },
});

export default FriendView;
