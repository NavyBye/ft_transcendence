import common from '../common';
import Game from '../game/Game';
import template from '../templates/GamePlayView.html';

const GuildWarTimeModalView = common.View.extend({
  el: '#game-play',
  template,
  events: {},
  onInitialize() {},
  onRender() {
    const game = new Game('game-play');
    this.game = game;
    setTimeout(function foo() {
      game.simulate(0.2);
      setTimeout(foo, 30);
    }, 30);
  },
});

export default GuildWarTimeModalView;
