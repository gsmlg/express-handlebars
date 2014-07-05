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
    it 'should render hello world', ->
      src = 'Hello {{name}}!'
      local = _.extend(opt, {name: 'World'})
      engine::render src, local, (err, data)->
        data.should.equal 'Hello World!'


  describe 'layout', ->
    opt = {}
    this.timeout 10000
    beforeEach (done)->
      engine.set 'useLayout', true
      opt = {}
      done()

    it 'should render in layout', (done)->
      file = join views, 'hello.hbs'
      opt.name = 'George'
      fn = (err, str)->
        throw err if err
        str.should.be.type 'string'
        str = str.trim()
        str.should.startWith '<html>'
        str.should.endWith '</html>'
        str.should.match /George/
        done()
      new engine(file, opt, fn)

    it 'should not render layout', (done)->
      engine.set 'useLayout', false
      file = join views, 'hello.hbs'
      opt.name = 'George'
      opt.layout = false
      new engine file, opt, (err, str)->
        throw err if err
        str.should.be.type 'string'
        str = str.trim()
        str.should.not.startWith '<html>'
        str.should.not.endWith '</html>'
        str.should.match /George/
        done()


  describe 'partials', ->
    opt = {}
    this.timeout 10000
    view = null
    beforeEach (done)->
      engine.set 'useLayout', false
      done()

    it 'should partials', (done)->
      file = join views, 'hello.hbs'
      opt.name = 'George'
      opt.partials = ['hello']
      new engine file, opt, (err, str)->
        throw err if err
        str.should.be.type 'string'
        str = str.trim()
        str.should.not.startWith '<html>'
        str.should.not.endWith '</html>'
        str.should.match /George/
        done()
