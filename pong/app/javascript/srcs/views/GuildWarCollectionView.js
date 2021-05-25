import collection from '../collections';
import common from '../common';
import template from '../templates/GuildWarCollectionView.html';
import GuildWarView from './GuildWarView';

const GuildWarCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#guild-war-collection',
  ViewType: GuildWarView,
  CollectionType: collection.GuildWarCollection,
  onRender() {},
  afterAdd() {},
});

export default GuildWarCollectionView;
