z = require 'zorium'

Conversion = require '../models/conversion'

module.exports = class ConversionCtrl
  getList: ->
    defer = z.deferred()

    # TODO add error log
    Conversion.all('conversions').getList()
      .then (conversions) -> defer.resolve conversions
      .then -> z.redraw()
    return defer.promise

  getResults: ({conversion, param, from, to}) ->
    prop = z.prop([])
    Conversion.one 'conversions', conversion
      .get {param: param, from: from, to: to}
      .then prop
      .then -> z.redraw()
    return prop
