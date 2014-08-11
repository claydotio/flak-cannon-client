z = require 'zorium'
_ = require 'lodash'

ConversionCtrl = new (require '../controllers/conversion')()

module.exports = class ConversionSelectorView
  constructor: ->
    @conversions = ConversionCtrl.find()

  render: ->
    z '.param-selector', _.map @conversions(), (conversion) ->
      z 'div', conversion.id
