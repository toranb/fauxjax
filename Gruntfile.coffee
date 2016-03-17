module.exports = (grunt) ->
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-karma')
  grunt.loadNpmTasks('grunt-karma-coveralls')
  grunt.initConfig

    coffee:
      options:
        bare: true
      compile:
        files: {"test/js/tests.min.js": "test/*.coffee"}

    karma:
      unit:
        configFile: "karma.conf.js"

    coveralls:
      options:
        debug: true
        coverageDir: "coverage/"
        dryRun: false
        force: true
        recursive: true

    uglify:
      my_target:
        files:
          "dist/fauxjax.min.js": ["src/lodash-4.6.1.js", "src/fauxjax.js"]

    grunt.task.registerTask("test", ["coffee", "uglify", "karma"])
    grunt.task.registerTask("deploy", ["coffee", "uglify", "karma", "coveralls"])
