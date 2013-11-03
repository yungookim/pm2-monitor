'use strict';

class pm2Monitor.Routers.MainRouter extends Backbone.Router

  routes :
    "" : "home"
    "remote/:url" : "load_remote"

  initialize : -> 
    # Global variable storages
    window.pm2Monitor.Globals = {}

  home : ->
    new pm2Monitor.Views.DashboardView 
      el : $ '#content'
      model : new pm2Monitor.Models.Pm2AppModel()

  load_remote : (url) ->
    new pm2Monitor.Views.DashboardView 
      el : $ '#content'
      model : new pm2Monitor.Models.Pm2AppModel({url : url})