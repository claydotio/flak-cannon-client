z = require 'zorium'
_ = require 'lodash'
Q = require 'q'

ParamCtrl = new (require '../controllers/param')()
ConversionCtrl = new (require '../controllers/conversion')()

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

    @results = z.prop {
      views: []
      counts: []
    }

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

  render: ->
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

        z 'input.go[type=submit][value=Show Me The Money!]', onclick: @submit
      ]

      z '.results-data', [
        JSON.stringify(@results())
      ]
    ]
