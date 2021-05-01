import collection from '../collections';
import common from '../common';
import template from '../templates/GuildRankingCollectionView.html';
import GuildRankingView from './GuildRankingView';

const GuildRankingCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#guild-ranking-collection',
  ViewType: GuildRankingView,
  CollectionType: collection.GuildRankingCollection,
  onRender() {},
});

export default GuildRankingCollectionView;
