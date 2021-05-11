import collection from '../collections';
import common from '../common';
import template from '../templates/GuildInviteCollectionView.html';
import GuildInviteView from './GuildInviteView';

const GuildInviteCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#guild-invite-collection',
  ViewType: GuildInviteView,
  CollectionType: collection.GuildInviteCollection,
  onRender() {},
  afterAdd() {},
});

export default GuildInviteCollectionView;
