module.exports = {
  entry: './src/index.js',
  presets: [
    require('poi-preset-elm')()
  ],
  html: {
    template: './src/index.html',
  },
}

