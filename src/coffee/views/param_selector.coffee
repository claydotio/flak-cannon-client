z = require 'zorium'
_ = require 'lodash'

ParamCtrl = new (require '../controllers/param')()

module.exports = class ParamSelectorView
  constructor: ->
    @params = ParamCtrl.getParams()

  render: ->
    z '.param-selector', _.map @params(), (param) ->
      z 'a', param.id
