gulp = require 'gulp'
{existsSync: exists, lstatSync: stat, readdirSync: readdir} = require 'fs'
{join} = require 'path'

class TaskManager
  constructor: (gulp)->
    @tasks = []
    @gulp = gulp

  load: (moduleName)->
    @lookup moduleName
    require(task)(@gulp) for task in @tasks
    @tasks = []
    @

  lookup: (moduleName)->
    moduleName ?= process.cwd() + '/tasks'
    if exists moduleName
      s = stat moduleName
      @tasks.push moduleName if s.isFile() and /\.gulp\.(js|coffee)$/.test(moduleName)
      @lookupDir moduleName if s.isDirectory()
    @

  lookupDir: (dir)->
    files = readdir dir
    @lookup join(dir, file) for file in files

tm = new TaskManager(gulp)

gulp.loadTasks = (moduleName)->
    tm.load moduleName

gulp.loadTasks join(__dirname, 'tasks')
