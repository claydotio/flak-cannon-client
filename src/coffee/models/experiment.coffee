resource = require '../lib/resource'
config = require '../config'

module.exports = resource.setBaseUrl(config.FC_API_URL).all('experiments')
