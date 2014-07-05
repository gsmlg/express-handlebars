{exec} = require 'child_process'
{join} = require 'path'
module.exports = (gulp)->
  gulp.task 'compile', (done)->
    src = join __dirname, '..', 'src'
    lib = join __dirname, '..', 'lib'
    exec "coffee --compile --output #{lib} #{src}", (err, stdout, stderr)->
      throw err if err
      console.log stdout if stdout
      console.log stderr if stderr
      done()
