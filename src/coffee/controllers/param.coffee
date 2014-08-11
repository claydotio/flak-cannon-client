z = require 'zorium'
Param = require '../models/param'

module.exports = class ParamCtrl
  getParams: ->
    params = z.prop()
    Param.getList().then params
    return params
