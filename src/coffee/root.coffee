Zock = require 'zock'
z = require 'zorium'

window.addEventListener 'fb-flo-reload', -> z.redraw()

HomePage = new (require './pages/home')()

z.route.mode = 'hash'
z.route document.getElementById('app'), '/',
  '/': HomePage
