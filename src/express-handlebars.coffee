engine = require './engine'
module.exports = engine

engine.__express = (name, options, fn)->
  new engine(name, options, fn)
