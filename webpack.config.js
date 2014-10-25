module.exports = {
    entry: "./src/entry.js",
    output: {
        path: __dirname,
        filename: "bundle2.js"
    },

    resolve: {
        // Allow to omit extensions when requiring these files
        extensions: ['', '.js', '.jsx']
    },
    module: {
        loaders: [
            { test: /\.css$/, loader: "style!css" },
            { test: /\.jsx$/, loader: 'jsx' },
        ]
    },
    externals: {
        // Showdown is not is node_modules,
        // so we tell Webpack to resolve it to a global
        'showdown': 'window.Showdown'
    },
    cache: false
};