express = require 'express'
http = require 'http'
path = require 'path'
coffee = require 'coffee-script'
fs = require 'fs'
hogan = require 'hogan.js'
stylus = require 'stylus'
nib = require 'nib'

app = module.exports = express()
isProduction = app.settings.env is 'production'

# Cache is used in production
cache = {}

app.configure ->
  app.set 'port', process.env.PORT or 4000
  app.use express.logger('dev')
  app.use express.compress()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

  app.use stylus.middleware
    src:__dirname + '/src/stylus',
    dest:__dirname + '/public'
    compile: (str, path) ->
      stylus(str).set('filename', path).set('compress', true).use(nib())

  app.use (req, res, next) =>
    if /\.coffee/.test req.url
      filename = path.basename req.url
      source =  "#{__dirname}/src/coffee/#{filename}"
      content = fs.readFileSync source, "ascii"
      res.contentType 'text/javascript'
      res.send coffee.compile content
    else if /\.hogan/.test req.url

      if isProduction and cache.hogan?
        result = cache.hogan
      else
        srcPath = "#{__dirname}/src/hogan/"

        namespace = "T"
        result = namespace + '={};'

        fs.readdirSync(srcPath).forEach (file) ->
          if path.extname(file) is ".hogan"
            content = fs.readFileSync srcPath + file
            compiledJS = hogan.compile content.toString(), {asString : true}
            template = path.basename file, ".hogan"
            result += '\n' + namespace + '.' + template + '=' + compiledJS

        cache.hogan = result

      res.header 'Content-Type', 'text/javascript'
      res.send result
    else
      next()

    
  app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

app.listen app.get('port')
console.log("Express server on port #{app.get('port')}");