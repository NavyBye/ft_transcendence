import _ from 'underscore';
import $ from 'jquery/src/jquery';
import Backbone from 'backbone';
import Region from './Region';

const View = Backbone.View.extend({
  preinitialize() {
    this.listenTo(this, 'initialize', this.onInitialize);
    this.listenTo(this, 'render', this.onRender);
    this.listenTo(this, 'destroy', this.onDestroy);
  },
  initialize(obj) {
    if (obj && obj.model) {
      this.model = obj.model;
      this.listenTo(this.model, 'change', this.render);
    }

    this.regions = {};

    this.trigger('initialize', obj);
  },
  render(selector) {
    const el = selector || this.el;
    this.template = this.template || _.template('');
    if (this.model) {
      $(el).html(this.template(this.model.toJSON()));
    } else {
      $(el).html(this.template());
    }
    this.trigger('render');
    return this;
  },
  destroy() {
    this.trigger('destroy');
    /* undo listenTo */
    this.stopListening();
    /* remove event handlers */
    this.undelegateEvents();
  },
  getRegion(regionName) {
    return this.regions[regionName];
  },
  addRegion(regionName, selector) {
    this.regions[regionName] = new Region(regionName, selector);
  },
  show(regionName, view) {
    const region = this.getRegion(regionName);
    region.show(view);
  },
});

export default View;
