express-handlebars
==================

express-handlebars for my express web

## Install
```
npm install express4-handlebars
```

## Settings
```
  engine = require 'express4-handlebars'
  extname = engine.get 'extname'

  app.engine extname, engine.__express
  app.set 'view engine', extname

  engine.set 'layout_dir', join(views_path, 'layout')
  engine.set 'partials_dir', join(views_path, 'partials')
  engine.set 'useLayout', true
  engine.set 'layout', 'layout'

```

## Feature
Auto load partials in partials_dir.
If useLayout is true will auto load layout.
```
app.get '/', (req, res)->
  res.render 'index', {
    layout: 'layout' # use false to disable layout
    # or like this `partials: { headbar: 'headbar-dark' }`
    partials: ['headbar'] # This will load partials from where index view in
  }
```

## Todos
- Replace express's View engine.
- Precompile all templates.
- Serve client side template for precompile.
