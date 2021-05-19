/* eslint-disable prettier/prettier */
import consumer from './consumer';

consumer.subscriptions.create('SignalChannel', {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // eslint-disable-next-line no-unused-vars
  received(data) {
    // Called when there's incoming data on the websocket for this channel
  },
});
