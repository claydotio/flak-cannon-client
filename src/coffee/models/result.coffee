resource = require '../lib/resource'
config = require '../config'

module.exports = resource.setBaseUrl(config.PUBLIC_FC_API_URL)
