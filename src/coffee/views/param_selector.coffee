z = require 'zorium'
_ = require 'lodash'

ParamCtrl = new (require '../controllers/param')()

module.exports = class ParamSelectorView
  constructor: ->
    @params = ParamCtrl.find()

  render: ->
    z '.param-selector', _.map @params(), (param) ->
      z 'div', param.id
