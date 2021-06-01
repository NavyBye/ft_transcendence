import Radio from 'backbone.radio';
import collection from '../collections';
import common from '../common';
import template from '../templates/DmRoomCollectionView.html';
import DmRoomView from './DmRoomView';

const DmRoomCollectionView = common.CollectionView.extend({
  template,
  childContainer: '#dmroom-collection',
  ViewType: DmRoomView,
  CollectionType: collection.DmRoomCollection,
  onInitialize() {
    const dmtab = document.getElementById('dm-notify');
    dmtab.style.display = 'none';
  },
  afterAdd() {
    const dmNotify = Radio.channel('dm').request('get');
    dmNotify.forEach(dmRoomId => {
      const dmRoom = document.getElementById(`${dmRoomId}-notify`);
      if (dmRoom) {
        dmRoom.style.display = 'inline-block';
      }
    });
  },
});

export default DmRoomCollectionView;
