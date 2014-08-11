Zock = require 'zock'
z = require 'zorium'

# window.XMLHttpRequest = ->
#   zock().XMLHttpRequest()

window.XMLHttpRequest = new Zock()
  .base('')
  .get('/params')
  .reply(200, [{id: 'testas'}])
  .XMLHttpRequest
