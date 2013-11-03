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
    $.get 'api/server_list', (ret) ->
      _.each ret, (remote)->
        # replace the slashes with ascii code
        remote = remote.replace /\//g, '&#47;'
        _link = $('<a/>').attr('href', "#remote/" + remote).html remote
        $('#remote_list').prepend $('<li/>').html(_link)

$ ->
  'use strict'
  pm2Monitor.init();
