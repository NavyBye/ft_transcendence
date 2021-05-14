import common from '../common';
import template from '../templates/GamePageView.html';
import DuelView from './DuelView';
import GuildWarView from './GuildWarView';
import LadderView from './LadderView';
import LadderTournamentView from './LadderTournamentView';
import TournamentView from './TournamentView';

const GamePageView = common.View.extend({
  el: '#content',
  template,
  events: {
    'click #left-button': 'leftRotate',
    'click #right-button': 'rightRotate',
  },
  onInitialize() {
    this.arr = [
      DuelView,
      LadderView,
      LadderTournamentView,
      TournamentView,
      GuildWarView,
    ];
    this.addRegion('box1', '#box1');
    this.addRegion('box2', '#box2');
    this.addRegion('box3', '#box3');
  },
  onRender() {
    this.show('box1', new this.arr[0]());
    this.show('box2', new this.arr[1]());
    this.show('box3', new this.arr[2]());
  },
  leftRotate() {
    const left = this.arr.shift();
    this.arr.push(left);
    this.render();
  },
  rightRotate() {
    const right = this.arr.pop();
    this.arr.unshift(right);
    this.render();
  },
});

export default GamePageView;
