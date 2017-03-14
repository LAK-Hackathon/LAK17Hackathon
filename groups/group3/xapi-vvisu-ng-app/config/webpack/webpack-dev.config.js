'use strict';

const webpack = require('webpack');
const WebpackMerge = require('webpack-merge');
const config = require('config');

const WebpackBaseConfig = require('./webpack-base.config');
const helpers = require('../../utils/helpers');

module.exports = WebpackMerge(WebpackBaseConfig, {
  devtool: 'cheap-module-source-map',
  output: {
    path: helpers.root(config.get('build.dist_folder')),
    filename: '[name].' + config.get('build.js_bundle_name'),
    sourceMapFilename: '[name].map'
  },
  module: {

    rules: [
    ]

  },
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ],
  devServer: {
    contentBase: helpers.root(config.get('app.src_folder')),
    compress: true,
    hot: true,
    inline: true,
    port: process.env.PORT || config.get('env.dev.port'),
    host: process.env.HOST || config.get('env.dev.host'),
    watchOptions: {
      aggregateTimeout: 300,
      poll: 1000
    }
  }
})
