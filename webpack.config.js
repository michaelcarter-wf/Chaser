module.exports = {
     entry: {
        chaser: "./src/entry.js",
        chaserEvents: "./src/events.js",
    },
    output: {
        // Make sure to use [name] or [id] in output.filename
        //  when using multiple entry points
        filename: "[name].bundle.js",
        chunkFilename: "[id].bundle.js"
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