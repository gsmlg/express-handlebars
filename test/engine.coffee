{join} = require 'path'
_ = require 'underscore'
engine = require '../src/engine'
should = require 'should'
dir = __dirname
views = join dir, 'views'
engine.set 'layout_dir', join(views, 'layout')
engine.set 'partials_dir', join(views, 'partials')
engine.set 'useLayout', false

describe 'engine', ->
  describe 'render', ->
    file = join(views, 'hello.hbs')
    opt = {partials: {}, helpers: {}, layout: false}
    view = new engine file, {}
    render = view.render
    it 'should render hello world', ->
      src = 'Hello {{name}}!'
      local = _.extend(opt, {name: 'World'})
      render src, local, (err, data)->
        data.should.equal 'Hello World!'


  describe 'layout', ->
    opt = {}
    view = null
    beforeEach (done)->
      engine.set 'useLayout', true
      done()

    it 'should render in layout', ->
      file = join views, 'hello.hbs'
      opt.name = 'George'
      new engine file, opt, (err, str)->
        console.error err.stack if err
        throw err if err
        str.should.be.type 'string'
        str.should.startWith '<html>'
        str.should.endWith '</html>'
        str.should.match /George/
