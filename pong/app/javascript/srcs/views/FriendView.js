import { Radio } from 'backbone';
import BootstrapMenu from 'bootstrap-menu';
import $ from 'jquery/src/jquery';
import common from '../common';
import template from '../templates/FriendView.html';

const FriendView = common.View.extend({
  template,
  onRender() {
    const id = this.model.get('id');
    const login = Radio.channel('app').request('login');
    this.menu = new BootstrapMenu(`.friend[id=${id}]`, {
      actions: [
        {
          name: 'Destroy',
          onClick() {
            $.ajax({
              type: 'DELETE',
              url: `/api/users/${login.get('id')}/friends/${id}`,
            });
          },
          classNames: 'dropdown-item',
        },
      ],
    });
  },
});

export default FriendView;
