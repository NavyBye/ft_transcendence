import common from '../common';
import template from '../templates/GuildInfoView.html';
import GuildMemberCollectionView from './GuildMemberCollectionView';

const GuildInfoView = common.View.extend({
  template,
  onInitialize() {
    this.addRegion('guild_member', '#guild-member');
  },
  onRender() {
    console.log(this.model);
    this.show(
      'guild_member',
      new GuildMemberCollectionView({ model: this.model }),
    );
  },
});

export default GuildInfoView;
