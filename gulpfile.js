var gulp = require('gulp');
var imageResize = require('gulp-image-resize');
var parallel = require("concurrent-transform");
var os = require("os");

gulp.task("default", function () {
  gulp.src("images/**/*.*")
    .pipe(parallel(
      imageResize({
        width: 200,
        height: 200,
        crop: true,
        upscale: false,
        imageMagick: true
      }),
      os.cpus().length
    ))
    .pipe(gulp.dest("thumbs"));
});