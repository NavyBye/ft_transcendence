import $ from 'jquery/src/jquery';
import common from '../common';

const UserProfileModalView = common.View.extend({
  el: '#addon-select-modal',
  events: {
    'click .enter-button': 'modeselect',
  },
  onInitialize(obj) {
    this.gamecard = obj.gamecard;
    const self = this;
    $(this.el).modal('show');
    $(this.el).on('hide.bs.modal', function destroy() {
      self.destroy();
    });
  },
  onRender() {},
  onDestroy() {},
  modeselect() {
    $(this.el).modal('hide');
    if ($('#default').is(':checked')) {
      this.gamecard.selectmode(false);
    } else {
      this.gamecard.selectmode(true);
    }
  },
});

export default UserProfileModalView;
