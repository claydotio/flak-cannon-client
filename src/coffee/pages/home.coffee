z = require 'zorium'

ResultsView = new (require '../views/results')()

module.exports = class HomePage
  view: ->
    z 'div.l-center-text', [
      ResultsView.render()
    ]
  controller: ->
    null
