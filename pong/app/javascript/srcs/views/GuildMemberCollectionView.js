import collection from '../collections';
import common from '../common';
import template from '../templates/GuildMemberCollectionView.html';
import GuildMemberView from './GuildMemberView';

const GuildMemberCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#guild-member-collection',
  ViewType: GuildMemberView,
  CollectionType: collection.GuildMemberCollection,
  onRender() {},
  afterAdd() {},
});

export default GuildMemberCollectionView;
