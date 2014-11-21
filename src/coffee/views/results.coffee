z = require 'zorium'
_ = require 'lodash'
Q = require 'q'

ExperimentCtrl = new (require '../controllers/experiment')()
ConversionCtrl = new (require '../controllers/conversion')()

module.exports = class ResultsView
  constructor: ->
    today = new Date()
    today.setDate today.getDate() + 1
    lastWeek = new Date()
    lastWeek.setDate lastWeek.getDate() - 7

    @from = z.prop @dateString lastWeek
    @to = z.prop @dateString today
    @viewCounter = z.prop 'default'

    @params = ExperimentCtrl.getList({from: @from(), to: @to()})
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
    ConversionCtrl.getResults
      param: @param()
      conversion: @conversion()
      from: @from()
      to: @to()
      viewCounter: @viewCounter()
    .then (results) ->
      _.map results, (result) ->
        return result
    .then @results
    .then -> z.redraw()
    .then null, ((x) -> console.error x)

  render: =>
    resultKeys = ['test', 'spark', 'count', 'views', 'conversion', 'p', 'delta']

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

        z 'span.label', 'View Counter'
        z 'select',
            {onchange: z.withAttr 'value', @viewCounter},
            _.map ['default', 'dau', 'd7'], (viewCounter) ->
              z 'option', {value: viewCounter}, viewCounter

        z 'input.go[type=submit][value=(╯°□°)╯︵ ┻━┻]', onclick: @submit
      ]

      z 'table.results-data', [
        _.map resultKeys,
          (t) -> z 'th', t

        _.map @results(), (result) ->
          z 'tr', _.map resultKeys, (key) ->
            datum = result[key]
            color = '#000'

            if key is 'conversion'
              datumPercentage = datum * 100
              datum = Math.round(datumPercentage * 1000) / 1000 + '%'
            if key is 'delta'
              datumPercentage = datum * 100
              datum = Math.round(datumPercentage * 1000) / 1000 + '%'
              if result.p < 0.05
                color = '#f00'
            if key is 'p'
              datum = datum?.toFixed 2
            if key is 'spark'
              return z 'td', {config: spark(result)}


            z 'td', {style: color: color}, datum
      ]
    ]


spark = (datum) ->

  ($el, isInit) ->
    if isInit
      return

    graph = new Rickshaw.Graph(
      element: $el
      width: 200
      height: 50
      renderer: 'line'
      series: [
        color: 'steelblue'
        data: _.map datum.sparkline, (y, i) ->
          {x: i, y: y or 0}
      ]
    )
    graph.render()
