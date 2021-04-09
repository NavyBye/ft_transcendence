function Region(regionName, selector) {
  this.regionName = regionName;
  this.selector = selector;

  this.view = null;
  this.show = function show(view) {
    if (this.view) this.view.destroy();

    this.view = view;
    this.view.render();
  };
}

export default Region;
