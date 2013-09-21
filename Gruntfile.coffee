module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.initConfig
    less:
      all:
        options:
          yuicompress: true
        files:
          'index/index.css': 'index/index.less'
          'media/metamorphosis-three.css': 'media/metamorphosis-three.less'

    coffee:
      all:
        options:
          sourcemap: true
        files:
          'index/index.js': 'index/index.coffee'

    watch:
      files: ['**/*.coffee', '**/*.less']
      tasks: ['compile']

  grunt.registerTask 'compile', ['coffee', 'less']
  grunt.registerTask 'default', ['compile']
