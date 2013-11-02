request = require "request"
nconf   = require 'nconf'
express        = require('express')
app            = express()

# In case this runs on Heroku
process.env.PWD = process.cwd()

app.configure ->
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

# Load configuration hierarch
if nconf.env().get('NODE_ENV')
  console.log 'Running Production Mode'
  nconf.env().argv().file process.env.PWD  + '/config.json'
  app.use express.static process.env.PWD  + '/../static/dist'
else 
  console.log 'Running Dev Mode'
  nconf.env().argv().file process.env.PWD  + '/devconfig.json'
  app.use express.static process.env.PWD  + '/../static/app'
  app.use express.static process.env.PWD  + '/../static/.tmp'

# TODO add support for multiple servers
app.get '/api/server', (req, res)->
  request nconf.get("hosts")[0], (error, response, body) ->
    res.json JSON.parse(body) if not error and response.statusCode is 200
    res.send 'error'

app.listen(nconf.get("port"));
console.log "Running on ", nconf.get("port")