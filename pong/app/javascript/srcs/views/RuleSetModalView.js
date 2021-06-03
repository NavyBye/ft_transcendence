import $ from 'jquery/src/jquery';
import common from '../common';

const RuleSetModalView = common.View.extend({
  el: '#ruleset-modal',
  show() {
    $(this.el).modal('show');
  },
});

export default RuleSetModalView;
