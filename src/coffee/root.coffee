Zock = require 'zock'
z = require 'zorium'

# window.XMLHttpRequest = new Zock()
#   .base('http://baseurl.com')
#   .get('/params')
#   .reply(200, [{id: 'test'}])
#   .XMLHttpRequest

window.addEventListener 'fb-flo-reload', -> z.redraw()

# xmlhttp = new XMLHttpRequest()
# xmlhttp.onreadystatechange = ->
#   if xmlhttp.readyState == 4
#     res = xmlhttp.responseText
#     res.should.be JSON.stringify({hello: 'world'})
#     done()
#
# xmlhttp.open('get', 'http://baseurl.com/test')
# xmlhttp.send()

HomePage = new (require './pages/home')()

z.route.mode = 'hash'
z.route document.getElementById('app'), '/',
  '/': HomePage
