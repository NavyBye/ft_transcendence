import { Radio } from 'backbone';
import common from '../common';
import template from '../templates/DmRoomView.html';

const DmRoomView = common.View.extend({
  template,
  events: {
    'click .enter-room': 'enterRoom',
  },
  enterRoom() {
    const dmRoomId = this.model.get('id');
    Radio.channel('side').trigger('enter-dmroom', dmRoomId);
  },
});

export default DmRoomView;
