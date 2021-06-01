import $ from 'jquery/src/jquery';
import common from '../common';
import GuildHistoryCollectionView from './GuildHistoryCollectionView';

const GuildHistoryModalView = common.View.extend({
  el: '#guild-history-modal',
  onInitialize() {
    const self = this;
    $('#guild-history-modal-title').html(this.model.get('name'));
    this.addRegion('guildHistory', '#guild-history');
    this.show(
      'guildHistory',
      new GuildHistoryCollectionView(this.model.get('id')),
    );
    $(this.el).modal('show');
    $(this.el).on('hide.bs.modal', function destroy() {
      self.destroy();
    });
  },
  onDestroy() {},
});

export default GuildHistoryModalView;
