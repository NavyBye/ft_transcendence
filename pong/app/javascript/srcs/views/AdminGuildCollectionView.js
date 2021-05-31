import collection from '../collections';
import common from '../common';
import template from '../templates/AdminGuildCollectionView.html';
import AdminGuildView from './AdminGuildView';

const AdminGuildCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#admin-guild-collection',
  ViewType: AdminGuildView,
  CollectionType: collection.GuildCollection,
  onRender() {},
  afterAdd() {},
});

export default AdminGuildCollectionView;
