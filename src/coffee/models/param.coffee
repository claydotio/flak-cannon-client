resource = require '../lib/resource'
config = require '../config'

module.exports = resource.setBaseUrl(config.API_URL).all('users')
