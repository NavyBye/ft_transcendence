import collection from '../collections';
import common from '../common';
import template from '../templates/GuildHistoryCollectionView.html';
import GuildHistoryView from './GuildHistoryView';

const GuildHistoryCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#guild-history-collection',
  ViewType: GuildHistoryView,
  CollectionType: collection.GuildHistoryCollection,
  onRender() {},
  afterAdd() {},
});

export default GuildHistoryCollectionView;
