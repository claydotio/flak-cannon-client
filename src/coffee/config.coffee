module.exports =
  FC_API_URL:
    if process.env.MOCK
    then ''
    else process.env.FC_API_URL or 'http://flak-cannon.i.clay.io'
