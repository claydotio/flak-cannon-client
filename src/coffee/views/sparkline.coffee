_ = require 'lodash'
d3 = require 'd3'
Rickshaw = require 'rickshaw'

module.exports = class SparklineView
  constructor: (@data) -> null

  sparkline: ($el, isInit) =>
    if isInit
      return

    palette = new Rickshaw.Color.Palette()
    graph = new Rickshaw.Graph(
      element: $el
      width: 100
      height: 50
      renderer: 'line'
      series: [
        data: _.map(@data, (datum, i) ->
          x: i
          y: datum
        )
        color: palette.color()
      ]
    )

    graph.render()


  render: =>
    z '.sparkline', {config: @sparkline}
