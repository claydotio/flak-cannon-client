_ = require 'lodash'
Q = require 'q'
z = require 'zorium'
Restangular = require 'restangular'

resource = {}
Restangular.call(resource)

request = (opts) ->
  opts = _.defaults opts, {
    deserialize: _.identity
    extract: (xhr, xhrOptions) ->
      data: JSON.parse(xhr.responseText)
      status: xhr.status
      headers: _.bind xhr.getResponseHeader, xhr
      config: xhrOptions
      statusText: xhr.statusText
    }

  z.request(opts)

_.assign(resource, resource.$get[2](request, Q))

module.exports = resource
