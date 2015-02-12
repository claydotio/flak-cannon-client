'use strict'

# Static assets
express = require 'express'
Promise = require 'bluebird'
rp = require 'request-promise'

config = require './src/coffee/config'

HEALTHCHECK_TIMEOUT = 100

app = express()

app.use '/healthcheck', (req, res) ->
  Promise.settle [
    Promise.cast(rp(config.FC_API_URL + '/ping'))
      .timeout HEALTHCHECK_TIMEOUT
  ]
  .spread (flakCannon) ->
    res.json
      FlakCannon: flakCannon.isFulfilled()
      healthy: flakCannon.isFulfilled()

app.use '/ping', (req, res) ->
  res.end 'pong'

if process.env.NODE_ENV is 'production'
  app.use express['static'](__dirname + '/dist')
else
  app.use express['static'](__dirname + '/build')

app.listen process.env.FLAK_CANNON_CLIENT_PORT or 50020

console.log 'Listening on port', process.env.FLAK_CANNON_CLIENT_PORT or 50020

# fb-flo - for live reload
flo = require('fb-flo')
fs = require('fs')

flo 'build',
  port: 8888
  host: 'localhost'
  verbose: false
  glob: [
    'js/bundle.js'
    'css/bundle.css'
  ]
, (filepath, callback) ->
  callback
    resourceURL: filepath
    contents: fs.readFileSync('build/' + filepath, 'utf-8').toString()
