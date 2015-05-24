/* Notes:
   - gulp/tasks/browserify.js handles js recompiling with watchify
   - gulp/tasks/browserSync.js watches and reloads compiled files
*/

var gulp     = require('gulp');
var config   = require('../config');
var watchify = require('./browserify')

gulp.task('watch', ['watchify'], function(callback) {
  gulp.watch(config.sass.src,   ['sass']);
  gulp.watch(config.markup.src, ['markup']);
  // Watchify will watch and recompile our JS, so no need to gulp.watch it
});

// gulp.task('watch', function() {
//   gulp.watch(config.coffee.src, ['coffee']);
//   gulp.watch(config.javascript.src, ['javascript']);
//   gulp.watch(config.sass.src,   ['sass']);
//   gulp.watch(config.markup.src, ['markup']);
//   // Watchify will watch and recompile our JS, so no need to gulp.watch it
// });

