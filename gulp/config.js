var dest = './public';
var src = './client';

module.exports = {
  sass: {
    src: src + '/css/**/*.{sass,scss}',
    dest: dest + '/css/',
    settings: {
      // indentedSyntax: true, // Enable .sass syntax!
      imagePath: 'images' // Used by the image-url helper
    }
  },
  coffee: {
    src: src + '/js/**/*.coffee',
    dest: dest + '/js/',
    settings: {
      bare: false
    }
  },
  javascript: {
    src: src + '/js/**/*.js*',
    dest: dest + '/js/'
  },
  markup: {
    src: [src + '/*.jade', '!' + src + '/_*.jade'],
    dest: dest
  },
  browserify: {
    // A separate bundle will be generated for each
    // bundle config in the list below
    bundleConfigs: [{
      entries: src + '/js/app.coffee',
      dest: dest + '/js/',
      outputName: 'app.js',
      // Additional file extentions to make optional
      extensions: ['.coffee', '.hbs']
      // list of modules to make require-able externally
      // require: ['jquery', 'underscore']

      // list of externally available modules to exclude from the bundle
      // external: ['jquery', 'underscore']
    },
    {
      entries: src + '/js/editor.coffee',
      dest: dest + '/js/',
      outputName: 'editor.js',
      // Additional file extentions to make optional
      extensions: ['.coffee', '.hbs']
      // list of modules to make require-able externally
      // require: ['jquery', 'underscore']

      // list of externally available modules to exclude from the bundle
      // external: ['jquery', 'underscore']
    }]
  },
  production: {
    cssSrc: dest + '/css/*.css',
    jsSrc: dest + '/js/*.js',
    dest: dest
  }
};

