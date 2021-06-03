import common from '../common';
import template from '../templates/RankPageView.html';
import UserRankingCollectionView from './UserRankingCollectionView';
import GuildRankingCollectionView from './GuildRankingCollectionView';

const RankPageView = common.View.extend({
  template,
  onRender() {
    this.addRegion('user_rank', '#user-rank');
    this.addRegion('guild_rank', '#guild-rank');
    this.show('user_rank', new UserRankingCollectionView());
    this.show('guild_rank', new GuildRankingCollectionView());
  },
});

export default RankPageView;
