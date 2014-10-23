z = require 'zorium'
_ = require 'lodash'

Conversion = require '../models/conversion'
Result = require '../models/result'
StatMath = require '../lib/stat_math'

module.exports = class ConversionCtrl
  getList: ->
    defer = z.deferred()

    # TODO add error log
    Conversion.all('conversions').getList()
      .then (conversions) -> defer.resolve conversions
      .then -> z.redraw()
    return defer.promise

  getResults: ({conversion, param, from, to}) ->
    defer = z.deferred()

    Result.one('results')
    .get {event: conversion, param: param, from: from, to: to}
      .then (results) ->
        viewed = _.map results.views, (view) ->
          test: view.param
          views: view.count

        counted = _.map viewed, (result) ->
          result.count = _.reduce results.counts, (sum, day) ->
            sum + _.reduce day, (sum, dayData) ->
              sum + (if dayData.value is result.test then dayData.count else 0)
            , 0
          , 0

          return result

        sorted = _.sortBy counted, (result) ->
          -result.count / result.views

        best = sorted[0]

        deltad = _.map sorted, (result) ->
          result.delta = result.count / result.views - best.count / best.views
          return result

        pd = _.map deltad, (result) ->
          unless result.delta is 0
            result.p = StatMath.nMinusOneChiSquare(
              result.count, result.views, best.count, best.views
            )
          return result

        sparklined = _.map pd, (result) ->
          result.sparkline = _.map results.counts, (day) ->
            _.find(day, {value: result.test})?.count
          return result

        defer.resolve(sparklined)
      .then null, (err) -> console.log err

    return defer.promise
