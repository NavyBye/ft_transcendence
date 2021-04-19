const { environment } = require('@rails/webpacker');

const webpack = require('webpack');

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'],
    _: 'underscore',
    Backbone: 'backbone',
    Marionette: 'backbone.marionette',
  }),
);

environment.loaders.prepend('html', {
  test: /\.html$/,
  loader: 'underscore-template-loader',
  query: {
    prependFilenameComment: __dirname,
  },
});

module.exports = environment;
