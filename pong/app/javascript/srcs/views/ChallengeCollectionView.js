import collection from '../collections';
import ChallengeView from './ChallengeView';
import common from '../common';
import template from '../templates/ChallengeCollectionView.html';

const ChallengeCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#challenge-collection',
  ViewType: ChallengeView,
  CollectionType: collection.ChallengeCollection,
  onInitialize() {},
});

export default ChallengeCollectionView;
