z = require 'zorium'

ParamSelectorView = new (require '../views/param_selector')()
# EventSelectorView = new (require '../views/event_selector')()
# ResultsView = new (require '../views/results')()

module.exports = class HomePage
  view: ->
    z 'div', [
      z 'div.l-sidebar', [
        z 'div', ParamSelectorView.render()
        # z 'div', EventSelectorView.render()
      ]
      # z 'div.l-content', ResultsView.render()
    ]
  controller: ->
    null
