'use strict';

const webpack = require('webpack');
const WebpackMerge = require('webpack-merge');
const config = require('config');

const DefinePlugin = require('webpack/lib/DefinePlugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const IgnorePlugin = require('webpack/lib/IgnorePlugin');
const LoaderOptionsPlugin = require('webpack/lib/LoaderOptionsPlugin');
const NormalModuleReplacementPlugin = require('webpack/lib/NormalModuleReplacementPlugin');
const ProvidePlugin = require('webpack/lib/ProvidePlugin');
const UglifyJsPlugin = require('webpack/lib/optimize/UglifyJsPlugin');
const OptimizeJsPlugin = require('optimize-js-plugin');
const CompressionPlugin = require('compression-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');


const WebpackBaseConfig = require('./webpack-base.config');
const helpers = require('../../utils/helpers');

console.log('\n\n', process.env, '\n\n')

module.exports = WebpackMerge(WebpackBaseConfig, {
    devtool: 'cheap-module-source-map',
    output: {
        path: helpers.root(config.get('build.dist_folder')),
        filename: '[name].[hash].' + config.get('build.js_bundle_name'),
        sourceMapFilename: '[name].[hash].bundle.map',
        chunkFilename: '[id].[hash].chunk.js',
    },
    module: {

        rules: [
            {
                test: /\.css$/,
                loader: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    use: 'css-loader'
                })
            },
            {
                test: /\.scss$/,
                loader: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    use: 'css-loader!sass-loader'
                }),
            },
        ]

    },
    plugins: [
        new webpack.DefinePlugin({
            FRB_API_KEY: JSON.stringify(process.env.FRB_API_KEY),
            FRB_AUTHDOMAIN: JSON.stringify(process.env.FRB_AUTHDOMAIN),
            FRB_DATABASEURL: JSON.stringify(process.env.FRB_DATABASEURL),
            FRB_STORAGEBUCKET: JSON.stringify(process.env.FRB_STORAGEBUCKET),
            FRB_MESSAGINGSENDERID: JSON.stringify(process.env.FRB_MESSAGINGSENDERID),
        }),
        new CopyWebpackPlugin([
            { from: helpers.root(config.get('build.assets_folder')), to: helpers.root(config.get('build.dist_assets_folder')) },
        ]),
        new webpack.HotModuleReplacementPlugin(),
        new OptimizeJsPlugin({
            sourceMap: false
        }),
        new CompressionPlugin({
            regExp: /\.css$|\.html$|\.js$|\.map$/,
            threshold: 2 * 1024
        }),
        new ExtractTextPlugin({
            filename: '[name].[contenthash].css',
            allChunks: true
        }),
        new UglifyJsPlugin({

            beautify: false, //prod
            output: {
                comments: false
            }, //prod
            mangle: {
                screw_ie8: true
            }, //prod
            compress: {
                screw_ie8: true,
                warnings: false,
                conditionals: true,
                unused: true,
                comparisons: true,
                sequences: true,
                dead_code: true,
                evaluate: true,
                if_return: true,
                join_vars: true,
                negate_iife: false // we need this for lazy v8
            },
        }),
        new LoaderOptionsPlugin({
            minimize: true,
            debug: false,
            options: {

                htmlLoader: {
                    minimize: true,
                    removeAttributeQuotes: false,
                    caseSensitive: true,
                    customAttrSurround: [
                        [/#/, /(?:)/],
                        [/\*/, /(?:)/],
                        [/\[?\(?/, /(?:)/]
                    ],
                    customAttrAssign: [/\)?\]?=/]
                },

            }
        }),
    ]
})
