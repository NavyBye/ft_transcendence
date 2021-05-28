import $ from 'jquery/src/jquery';
import BootstrapMenu from 'bootstrap-menu';
import common from '../common';
import auth from '../utils/auth';
import template from '../templates/AdminUserView.html';
import OkModalView from './OkModalView';

const AdminUserView = common.View.extend({
  template,
  tagName: 'tr',
  className: 'row',
  onInitialize() {},
  onRender() {
    const self = this;
    this.menu = new BootstrapMenu(`[user-id=${this.model.get('id')}]`, {
      actions: [
        {
          name: 'Ban',
          classNames: 'dropdown-item',
          onClick() {
            $.ajax({
              type: 'PUT',
              url: `/api/users/${self.model.get('id')}`,
              headers: auth.getTokenHeader(),
              data: { is_banned: true },
              success() {
                self.model.fetch();
                new OkModalView().show(
                  'Success',
                  'Successfully change user data',
                );
              },
            });
          },
        },
        {
          name: 'free',
          classNames: 'dropdown-item',
          onClick() {
            $.ajax({
              type: 'PUT',
              url: `/api/users/${self.model.get('id')}`,
              headers: auth.getTokenHeader(),
              data: { is_banned: false },
              success() {
                self.model.fetch();
                new OkModalView().show(
                  'Success',
                  'Successfully change user data',
                );
              },
            });
          },
        },
        {
          name: 'give admin',
          classNames: 'dropdown-item',
          onClick() {
            $.ajax({
              type: 'PUT',
              url: `/api/users/${self.model.get('id')}`,
              headers: auth.getTokenHeader(),
              data: { role: 'admin' },
              success() {
                self.model.fetch();
                new OkModalView().show(
                  'Success',
                  'Successfully change user data',
                );
              },
            });
          },
        },
        {
          name: 'take admin',
          classNames: 'dropdown-item',
          onClick() {
            $.ajax({
              type: 'PUT',
              url: `/api/users/${self.model.get('id')}`,
              headers: auth.getTokenHeader(),
              data: { role: 'user' },
              success() {
                self.model.fetch();
                new OkModalView().show(
                  'Success',
                  'Successfully change user data',
                );
              },
            });
          },
        },
      ],
    });
  },
});

export default AdminUserView;
