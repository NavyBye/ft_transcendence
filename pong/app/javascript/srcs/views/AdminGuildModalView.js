import $ from 'jquery/src/jquery';
import common from '../common';
import AdminGuildMemberCollectionView from './AdminGuildMemberCollectionView';

const AdminGuildModalView = common.View.extend({
  el: '#admin-guild-modal',
  onInitialize(obj) {
    const self = this;
    this.addRegion('guildmember', '#guild-member');
    this.show('guildmember', new AdminGuildMemberCollectionView(obj));
    $(this.el).modal('show');
    $(this.el).on('hide.bs.modal', function destroy() {
      self.destroy();
    });
  },
  onRender() {},
  onDestroy() {},
});

export default AdminGuildModalView;
