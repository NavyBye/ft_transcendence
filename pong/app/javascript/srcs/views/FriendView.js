/* eslint-disable no-new */
import UserProfileModalView from './UserProfileModalView';
import common from '../common';
import template from '../templates/FriendView.html';
import consumer from '../../channels/consumer';

const FriendView = common.View.extend({
  template,
  events: {
    'click img': 'showProfile',
  },
  onInitialize() {
    const self = this;
    this.channel = consumer.subscriptions.create(
      {
        channel: 'FriendChannel',
        id: self.model.get('id'),
      },
      {
        connected() {},
        disconnected() {},
        received(data) {
          self.model.set({ status: data.data.status });
          self.render();
        },
      },
    );
  },
  onRender() {},
  showProfile() {
    new UserProfileModalView(this.model.get('id'));
  },
});

export default FriendView;
