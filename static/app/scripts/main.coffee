window.pm2Monitor =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    'use strict'
    new @Routers.MainRouter()
    Backbone.history.start()
    console.log 'Hello from Backbone!'

$ ->
  'use strict'
  pm2Monitor.init();
