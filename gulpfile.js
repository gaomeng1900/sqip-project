var gulp        = require('gulp');
var browserSync = require('browser-sync').create();
var sass        = require('gulp-sass');
var reload      = browserSync.reload;
var coffee      = require('gulp-coffee');

var env_0 = process.argv.slice(2)[2];
var env_1 = process.argv.slice(2)[4];


// 静态服务器 + 监听 scss/html 文件
gulp.task('serve', ['sass'], function() {
    console.log(env_0 + ( env_1 ? ('/'+env_1) : '' ));
    
    browserSync.init({
        server: './' + env_0 + ( env_1 ? ('/'+env_1) : '' ) + '/public'
    });

    gulp.watch(env_0 + ( env_1 ? ('/'+env_1) : '' ) + "/src/scss/*.scss", ['sass']);
    gulp.watch(env_0 + ( env_1 ? ('/'+env_1) : '' ) + "/src/coffee/*.coffee", ['coffee']);
    gulp.watch(env_0 + ( env_1 ? ('/'+env_1) : '' ) + "/public/*.html").on('change', reload);
});

// scss编译后的css将注入到浏览器里实现更新
gulp.task('sass', function() {
    return gulp.src(env_0 + ( env_1 ? ('/'+env_1) : '' ) + "/src/scss/*.scss")
        .pipe(sass())
        .pipe(gulp.dest(env_0 + ( env_1 ? ('/'+env_1) : '' ) + "/public/css"))
        .pipe(reload({stream: true}));
});

// 编译coffee script
gulp.task('coffee', function() {
  gulp.src(env_0 + ( env_1 ? ('/'+env_1) : '' ) + "/src/coffee/*.coffee")
    .pipe(coffee({bare:"bare"}))
    .pipe(gulp.dest(env_0 + ( env_1 ? ('/'+env_1) : '' ) + '/public/js/'))
    .pipe(reload({stream: true}));
});

// 复制 bower_components 中的所有文件到 js/lib
gulp.task('js_lib', function(){
    gulp.src('bower_components/**')
        .pipe(gulp.dest(env_0 + ( env_1 ? ('/'+env_1) : '' ) + '/public/js/lib/'))
});

gulp.task('com', ['serve','sass','coffee', 'js_lib']);