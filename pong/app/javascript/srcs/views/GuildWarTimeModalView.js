import $ from 'jquery/src/jquery';
import common from '../common';

const GuildWarTimeModalView = common.View.extend({
  el: '#guild-war-time-modal',
  events: {
    'click .select-button': 'selectWarTime',
  },
  onInitialize() {
    $(this.el).modal('show');

    const view = this;
    $(this.el).on('hide.bs.modal', function destroy() {
      view.destroy();
    });
  },
  onDestroy() {
    $('#guild-war-time-modal input').val('');
  },
  selectWarTime() {
    $(this.el).modal('hide');
  },
});

export default GuildWarTimeModalView;
