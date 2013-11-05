request = require 'request'
nconf   = require 'nconf'
express = require 'express'
_       = require 'underscore'
colors  = require 'colors'
app     = express()


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
  app.use express.static process.env.PWD  + '/../presentation/dist'
else 
  console.log 'Running Dev Mode'
  nconf.env().argv().file process.env.PWD  + '/devconfig.json'
  app.use express.static process.env.PWD  + '/../presentation/app'
  app.use express.static process.env.PWD  + '/../presentation/.tmp'

# Test if all remote hosts are valid
num_pass = 0;
_.each nconf.get("hosts"), (host) ->
  console.log ("Checking " + host).rainbow
  request host, (err, res, body) ->
    # If the hosts are not reachable at initiation, then exit
    # TODO : Add -f so that even if the check fails, the process will still run
    console.error(('The host ' + host + ' is not reachable. Check the firewall or make sure "pm2 web" is running xD').underline.red) if err
    console.error('I\'m killing myself') process.exit(1) if err
    console.log (host + ' OK').green
    num_pass++;
    start() if num_pass is nconf.get('hosts').length

app.get '/api/server_list', (req, res)->
    res.send nconf.get "hosts"

app.get '/api/remote/:url', (req, res)->
  remote_addr = req.params.url.replace /&#47;/g, '/'
  request remote_addr, (error, response, body) ->
    console.log response
    res.json JSON.parse(body) if not error and response.statusCode is 200
    res.send error

start = () ->
  app.listen nconf.get "port"
  console.log "Running on".green, nconf.get("port")