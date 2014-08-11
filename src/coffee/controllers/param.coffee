z = require 'zorium'

Param = require '../models/param'

module.exports = class ParamCtrl
  getList: ->
    defer = z.deferred()

    # TODO add error log
    Param.all('params').getList()
      .then (params) -> defer.resolve params
      .then -> z.redraw()
    return defer.promise
