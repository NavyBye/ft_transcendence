import Radio from 'backbone.radio';
import BootstrapMenu from 'bootstrap-menu';
import $ from 'jquery/src/jquery';
import common from '../common';
import auth from '../utils/auth';
import template from '../templates/GuildWarView.html';
import OkModalView from './OkModalView';

const GuildWarView = common.View.extend({
  template,
  tagName: 'tr',
  onInitialize() {},
  onRender() {
    const self = this;
    this.menu = new BootstrapMenu(`[war-id=${this.model.get('id')}]`, {
      actions: [
        {
          name: 'ACCPET',
          onClick() {
            $.ajax({
              type: 'PUT',
              url: `/api/declarations/${self.model.get('id')}`,
              headers: auth.getTokenHeader(),
              success() {
                new OkModalView().show('Success', 'Successfully Accept War');
                Radio.channel('guildwar').request('refresh');
              },
            });
          },
          classNames: 'dropdown-item',
        },
        {
          name: 'REFUSE',
          onClick() {
            $.ajax({
              type: 'DELETE',
              url: `/api/declarations/${self.model.get('id')}`,
              headers: auth.getTokenHeader(),
              success() {
                new OkModalView().show('Success', 'Successfully Refuse War');
                Radio.channel('guildwar').request('refresh');
              },
            });
          },
          classNames: 'dropdown-item',
        },
      ],
    });
  },
});

export default GuildWarView;
