import common from '../common';
import template from '../templates/GamePageView.html';
import DuelCardView from './DuelCardView';
import GuildWarCardView from './GuildWarCardView';
import LadderCardView from './LadderCardView';
import LadderTournamentCardView from './LadderTournamentCardView';
import TournamentCardView from './TournamentCardView';

const GamePageView = common.View.extend({
  el: '#content',
  template,
  events: {
    'click #left-button': 'leftRotate',
    'click #right-button': 'rightRotate',
    'click #box1': function click() {
      this.getRegion('box1').getView().click();
    },
    'click #box2': function click() {
      this.getRegion('box2').getView().click();
    },
    'click #box3': function click() {
      this.getRegion('box3').getView().click();
    },
  },
  onInitialize() {
    this.arr = [
      DuelCardView,
      LadderCardView,
      LadderTournamentCardView,
      TournamentCardView,
      GuildWarCardView,
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
