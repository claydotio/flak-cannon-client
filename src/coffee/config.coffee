module.exports =
  FC_API_URL:
    if process.env.MOCK
    then ''
    else process.env.PUBLIC_FC_API_URL or 'https://flak-cannon.kiln.wtf'
