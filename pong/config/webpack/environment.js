const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
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
