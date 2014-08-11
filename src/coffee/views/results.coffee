z = require 'zorium'
_ = require 'lodash'
Q = require 'q'

ParamCtrl = new (require '../controllers/param')()
ConversionCtrl = new (require '../controllers/conversion')()
Sparkline = require '../views/sparkline'

module.exports = class ResultsView
  constructor: ->
    today = new Date()
    lastWeek = new Date()
    lastWeek.setDate lastWeek.getDate() - 7

    @from = z.prop @dateString lastWeek
    @to = z.prop @dateString today

    @params = ParamCtrl.getList({from: @from(), to: @to()})
    @conversions = ConversionCtrl.getList({from: @from(), to: @to()})

    @param = z.prop @params[0]?.id
    @conversion = z.prop @conversions[0]?.id

    @results = z.prop []

    # TODO error handling
    Q.all([@params, @conversions]).spread (params, conversions) =>
      @param params[0].id
      @conversion conversions[0].id
      @submit()

  dateString: (date) ->
    year = date.getFullYear()
    month = date.getMonth() + 1
    day = date.getDate()

    if day < 10
      day = '0' + day

    if month < 10
      month = '0' + month

    return "#{year}-#{month}-#{day}"

  submit: =>
    @results = ConversionCtrl.getResults
      param: @param()
      conversion: @conversion()
      from: @from()
      to: @to()
    .then (results) ->
      _.map results, (result) ->
        result.sparkline = new Sparkline(result.sparkline)
        return result

  render: ->
    resultKeys = ['test', 'sparkline', 'count', 'views', 'p', 'delta']

    z '.results', [
      z '.results-header', [
        z 'span.label', 'Param'
        z 'select',
          {onchange: z.withAttr 'value', @param},
          _.map @params(), (param) ->
            z 'option', value: param.id, param.id

        z 'span.label', 'Conversion'
        z 'select',
          {onchange: z.withAttr 'value', @conversion},
          _.map @conversions(), (conversion) ->
            z 'option', {value: conversion.id}, conversion.id

        z 'br'

        z 'span.label', 'From'
        z 'input[type=date]',
          onchange: z.withAttr 'value', @from
          value: @from()

        z 'span.label', 'To'
        z 'input[type=date]',
          onchange: z.withAttr 'value', @to
          value: @to()

        z 'input.go[type=submit][value=(╯°□°)╯︵ ┻━┻]', onclick: @submit
      ]

      z 'table.results-data', [
        _.map resultKeys,
          (t) -> z 'th', t

        _.map @results(), (result) ->
          z 'tr', _.map resultKeys, (key) ->
            datum = result[key]
            if key is 'delta'
              datum = Math.floor(datum * 100) + '%'
            if key is 'sparkline'
              datum = datum.render()
            z 'td', datum
      ]
    ]
