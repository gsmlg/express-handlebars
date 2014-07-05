{exec} = require 'child_process'
{join} = require 'path'
module.exports = (gulp)->
  gulp.task 'test', (done)->
    src = join __dirname, '..', 'src'
    lib = join __dirname, '..', 'lib'
    mocha = 'node_modules/mocha/bin/mocha'
    exec "node #{mocha} --compilers coffee:coffee-script/register --reporter spec", (err, stdout, stderr)->
      throw err if err
      console.log stdout if stdout
      console.log stderr if stderr
      done()
