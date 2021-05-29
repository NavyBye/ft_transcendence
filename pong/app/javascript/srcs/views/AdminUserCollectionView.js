import collection from '../collections';
import common from '../common';
import template from '../templates/AdminUserCollectionView.html';
import AdminUserView from './AdminUserView';

const AdminUserCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#admin-user-collection',
  ViewType: AdminUserView,
  CollectionType: collection.UserCollection,
  onRender() {},
  afterAdd() {},
});

export default AdminUserCollectionView;
