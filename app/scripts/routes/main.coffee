'use strict';

class pm2Monitor.Routers.MainRouter extends Backbone.Router

  routes :
    "" : "landing"

  initialize : -> 
    # Global variable storages
    window.pm2Monitor.Globals = {}

  landing : ->
    