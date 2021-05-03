/* eslint-disable prefer-destructuring */
import $ from 'jquery/src/jquery';
import common from '../common';
import ChatRoomUserCollectionView from './ChatRoomUserCollectionView';

const ChatRoomUserCollectionModalView = common.View.extend({
  el: '#chatRoomUserModal',
  onInitialize(obj) {
    this.collectionView = new ChatRoomUserCollectionView(obj);
    const collectionView = this.collectionView;
    $('#chatRoomUserModal .modal-body').append(collectionView.render().el);
    $('#chatRoomUserModal').on('hide.bs.modal', function hide() {
      $('#chatRoomUserModal .modal-body').html('');
      collectionView.destroy();
    });
  },
});

export default ChatRoomUserCollectionModalView;
