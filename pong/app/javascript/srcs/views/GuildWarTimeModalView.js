import $ from 'jquery/src/jquery';
import auth from '../utils/auth';
import common from '../common';

const GuildWarTimeModalView = common.View.extend({
  el: '#guild-war-time-modal',
  events: {
    'click .table': 'selectTime',
  },
  onInitialize() {
    $(this.el).modal('show');

    const view = this;
    $(this.el).on('hide.bs.modal', function destroy() {
      view.destroy();
    });
    $.ajax({
      type: 'GET',
      url: `api/wartimes`,
      auth: auth.getTokenHeader(),
      success(data) {
        data.forEach(function setTime(time) {
          document.querySelector(`#time-${time}`).innerText = 'X';
        });
      },
    });
  },
  onDestroy() {
    $('#guild-war-time-modal input').val('');
  },
  selectTime(event) {
    const parent = event.target.closest('.row');
    const value = parent.querySelector('.col-8').innerText;
    const time = parent.getAttribute('time');
    if (time && value === 'O') {
      $('#war-time').attr('time', time);
      $(this.el).modal('hide');
    }
  },
});

export default GuildWarTimeModalView;
