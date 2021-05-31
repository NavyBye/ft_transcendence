import collection from '../collections';
import common from '../common';
import template from '../templates/AdminGuildMemberCollectionView.html';
import AdminGuildMemberView from './AdminGuildMemberView';

const AdminGuildMemberCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#admin-guild-member-collection',
  ViewType: AdminGuildMemberView,
  CollectionType: collection.GuildMemberCollection,
  onRender() {},
  afterAdd() {},
});

export default AdminGuildMemberCollectionView;
