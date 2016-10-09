var path = require("path")
var CopyPlugin = require("copy-webpack-plugin")

module.exports = {
  entry: {
    app: [
      './src/index.js'
    ]
  },

    plugins: [
        new CopyPlugin([
            {
                context: "src/",
                from: "*.png",
            }
        ])
    ],

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
  },

  module: {
    loaders: [
      {
        test: /\.(css|scss|sass)$/,
        loaders: [
          'style-loader',
          'css-loader',
          'sass-loader?includePaths[]='+ path.resolve(__dirname, 'node_modules/bulma'),
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
  },

  devServer: {
    inline: true,
    stats: { colors: true },
  },

};
