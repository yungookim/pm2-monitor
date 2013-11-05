'use strict';

class presentation.Routers.MainRouter extends Backbone.Router

  routes :
    "" : "dashbaord"
    "remote/:url" : "load_remote"

  initialize : -> 
    # Global variable storages
    window.presentation.Globals = window.presentation.Globals or {}
    window.presentation.Globals.host_urls = []
    window.presentation.Globals.remote_collection = new presentation.Collections.RemotesCollection()
    # Get the list of hosts we want to query
    $.get 'api/server_list', (ret) ->
      _.each ret, (remote)->
        # Because slashes suck for naming an object and to send it to the server
        remote = remote.replace /\//g, '&#47;'

        window.presentation.Globals.remote_collection.push new presentation.Models.HostModel url : remote

        # replace the slashes with ascii code
        _link = $('<a/>').attr('href', "#remote/" + remote).html remote
        $('#remote_list').prepend $('<li/>').html _link

  dashbaord : ->
    new presentation.Views.DashboardView 
      el : $ '#content'
      collection : window.presentation.Globals.remote_collection

  load_remote : (url) ->

    new presentation.Views.RemoteView 
      el : $ '#content'
      model : new presentation.Models.HostModel url : url
      