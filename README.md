# Leve

Leve ([port. light](http://en.pons.eu/portuguese-english/leve)) is a lightweight node.js stack for mobile web apps.

* [Express](http://expressjs.com)
* [CoffeeScript](http://coffeescript.org)
* [Hogan](http://twitter.github.com/hogan.js)
* [Stylus](http://learnboost.github.com/stylus) with [Nib](http://visionmedia.github.io/nib/)
* [Zepto.js](http://zeptojs.com/)

It contains a Procfile so it can be pushed to [Heroku](https://www.heroku.com).
CoffeeScript, Hogan and Stylus are being compiled on the fly.
When the environment is set to 'production' caching is enabled.

    $ heroku config:add NODE_ENV=production

## Usage

Install CoffeeScript and [node-dev](https://github.com/fgnass/node-dev):

    $ sudo npm install -g coffee-script
    $ sudo npm install -g node-dev

Install dependencies:

    $ npm install .

Run local server:

    $ node-dev app.coffee

Open browser and point to [localhost:4000](http://localhost:4000)

## License

(The MIT License)

Copyright (c) 2013 Sönke Rohde [http://soenkerohde.com](http://soenkerohde.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.