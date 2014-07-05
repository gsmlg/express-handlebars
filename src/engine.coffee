fs = require 'fs'
{join, extname, dirname, resolve} = require 'path'
handlebars = require 'handlebars'
_ = require 'underscore'
glob = require 'glob'

module.exports = class engine
  self = @
  _settings =
    extname: '.hbs'
    useLayout: true
    layout: 'layout'
    partials_dir: null
    layout_dir: null
    helpers: {}
  @get = (name)->
    if name?
      _settings[name]
    else
      _.clone _settings
  @set = (name, value)->
    sets = {}
    if typeof name is 'string' and value?
      sets[name] = value
    else if typeof name is 'object'
      sets = name
    else
      return @
    _settings[k] = v for k,v of sets
  constructor: (path, options, fn)->
    that = @
    options.fileName = path
    options.layout = self.get('layout') if options.layout != false and self.get('useLayout')
    options.partials ?= []
    glob join(self.get('partials_dir'),'**', '*' + extname(path)), (err, files)->
      options.partials.concat files if files
      that.read_partials_and_layout path, options, (err)->
        return fn err if err
        that.read path, options, (err, str)->
          return fn(err) if err
          that.render str, options, fn

  render: (str, options, fn)->
    partials = options.partials
    helpers = options.helpers
    handlebars.registerPartial name, partial for name, partial of partails
    handlebars.regitserHelper name, helper for name, helper of helpers
    if options.layout?
      handlebars.registerPartial 'yield', str
      template = handlebars.compile layout
    else
      template = handlebars.compile str
    fn null, template(options)

  read_partials_and_layout: (path, options, fn)->
    return fn(null) if not options.partials? and not options.layout?
    that = @
    partials = options.partials
    file_ext = extname path or self.get('extname')
    options.partials = {}
    names = {}
    if _.isArray partials
      names[n] = n for n in partials
    else
      names[k] = v for k, v of partials
    keys = Object.keys names
    if options.layout?
      layout = if extname options.layout is file_ext then options.layout else options.layout + file_ext
      layout = join self.get('layout_dir'), layout if not isAbsolute layout

    next = (index)->
      return fn(null) if index is names.length
      key = keys[index]
      name = if extname names[key] is file_ext then names[key] else names[key] + file_ext
      file = join dirname(path), name if not isAbsolute name
      that.read file, options, (err, str)->
        return fn(err) if err
        options.partials[name] = str
        next index++

    if layout?
      @read layout, options, (err, str)->
        return fn(err) if err
        options.layout = str
        next 0
    else
      next 0

  read: (path, options, fn)->
    fs.readFile path, 'utf8', (err, str)->
      return fn(err) if err
      str = str.substr 1 if str[0] is '\uFEFF' # remove bom
      fn null, str


isAbsolute = (path)->
  if ('/' == path[0])
    return true
  if (':' == path[1] && '\\' == path[2])
    return true
  if ('\\\\' == path.substring(0, 2))
    return true # Microsoft Azure absolute path
  false
