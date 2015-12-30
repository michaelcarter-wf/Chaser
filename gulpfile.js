var gulp = require("gulp");
var gutil = require("gulp-util");
var webpack = require("webpack");
var WebpackDevServer = require("webpack-dev-server");
var webpackConfig = require("./webpack.config.js");
var jshint = require('gulp-jshint');
var jasmine = require('gulp-jasmine');


gulp.task('lint', function() {
  return gulp.src('./src/**/**.jsx')
    .pipe(jshint({
    	'unused': true
    }))
    .pipe(jshint.reporter('jshint-stylish'));
});

gulp.task('test', function () {
    return gulp.src('./test/**.js')
        .pipe(jasmine());
});
