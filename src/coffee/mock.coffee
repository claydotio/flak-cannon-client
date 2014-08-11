Zock = require 'zock'
z = require 'zorium'

mock = z.prop(new Zock()
  .base '/api/v2'
  .get '/params'
  .reply 200, [
    {id: 'login_button'}
    {id: 'signup_button'}
    {id: 'message_button'}
    {id: 'play_button_color'}
    {id: 'share_button_size'}
  ]
  .get '/conversions'
  .reply 200, [
    {id: 'game_play'}
    {id: 'game_share'}
    {id: 'signup'}
    {id: 'message_friend'}
  ]
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
