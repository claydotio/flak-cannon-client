z = require 'zorium'

Param = require '../models/param'

module.exports = class ParamCtrl
  find: ->
    params = z.prop()
    Param.getList()
    .then params
    .then -> z.readraw()
    return params
