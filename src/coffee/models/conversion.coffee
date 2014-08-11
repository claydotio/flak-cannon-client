z = require 'zorium'

config = require '../config'
resource = require '../lib/resource'

module.exports = resource.setBaseUrl(config.API_URL).all('conversions')
