z = require 'zorium'

Experiment = require '../models/experiment'

module.exports = class ParamCtrl
  getList: ->
    defer = z.deferred()

    # TODO add error log
    Experiment.getList()
      .then (params) -> defer.resolve params
      .then -> z.redraw()
    return defer.promise
