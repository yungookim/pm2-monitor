'use strict';

class pm2Monitor.Routers.MainRouter extends Backbone.Router

  routes :
    "" : "home"
    "remote/:url" : "load_remote"

  initialize : -> 
    # Global variable storages
    window.pm2Monitor.Globals = window.pm2Monitor.Globals or {}
    window.pm2Monitor.Globals.host_models = {}

    # Get the list of hosts we want to query
    $.get 'api/server_list', (ret) ->
      _.each ret, (remote)->
        # Because slashes suck for naming an object and to send it to the server
        remote = remote.replace /\//g, '&#47;'
        # replace the slashes with ascii code
        _link = $('<a/>').attr('href', "#remote/" + remote).html remote
        $('#remote_list').prepend $('<li/>').html _link

  home : ->
    # new pm2Monitor.Views.DashboardView 
      # el : $ '#content'
      # model : new pm2Monitor.Models.Pm2AppModel()

  load_remote : (url) ->
    new pm2Monitor.Views.DashboardView 
      el : $ '#content'
      model : new pm2Monitor.Models.Pm2AppModel url : url
      