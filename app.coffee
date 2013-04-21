# Copyright (c) 2013 Sönke Rohde http://soenkerohde.com
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the 'Software'), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

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