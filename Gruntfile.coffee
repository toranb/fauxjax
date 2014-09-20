module.exports = (grunt) ->
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks('grunt-testem-frontage')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-karma')
  grunt.initConfig

    coffee:
      options:
        bare: true
      compile:
        files: {"test/js/tests.min.js": "test/*.coffee"}

    karma:
      unit:
        configFile: "karma.conf.js"

    uglify:
      my_target:
        files:
          "dist/fauxjax.min.js": ["src/lodash.min.js", "src/fauxjax.js"]

    grunt.task.registerTask("test", ["coffee", "uglify", "testem"])
    grunt.task.registerTask("deploy", ["coffee", "uglify"])
