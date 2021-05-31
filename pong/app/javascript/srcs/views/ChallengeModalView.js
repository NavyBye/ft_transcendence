import $ from 'jquery/src/jquery';
import common from '../common';
import ChallengeCollectionView from './ChallengeCollectionView';

const ChallengeModalView = common.View.extend({
  el: '#challenge-modal',
  events: {},
  onInitialize() {
    const self = this;
    this.addRegion('challenge', '#challenge');
    $(this.el).modal('show');
    this.show('challenge', new ChallengeCollectionView());
    $(this.el).on('hide.bs.modal', function destroy() {
      self.destroy();
    });
  },
});

export default ChallengeModalView;
