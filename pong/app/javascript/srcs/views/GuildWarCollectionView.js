import Radio from 'backbone.radio';
import collection from '../collections';
import common from '../common';
import template from '../templates/GuildWarCollectionView.html';
import GuildWarView from './GuildWarView';

const GuildWarCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#guild-war-collection',
  ViewType: GuildWarView,
  CollectionType: collection.GuildWarCollection,
  onInitialize() {
    const self = this;
    Radio.channel('guildwar').reply('refresh', function refresh() {
      self.collection.fetch({
        reset: true,
        success() {
          self.reRender();
        },
      });
    });
  },
  onRender() {},
  afterAdd() {},
});

export default GuildWarCollectionView;
