z = require 'zorium'

Conversion = require '../models/conversion'

module.exports = class ConversionCtrl
  find: ->
    conversions = z.prop()
    Conversion.getList()
    .then conversions
    .then -> z.readraw()
    return conversions
