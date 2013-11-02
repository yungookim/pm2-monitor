'use strict';

class pm2Monitor.Routers.MainRouter extends Backbone.Router

  routes :
    "" : "home"

  initialize : -> 
    # Global variable storages
    window.pm2Monitor.Globals = {}

  home : ->
    new pm2Monitor.Views.MainView 
      el : $ '#content'
      model : new pm2Monitor.Models.Pm2AppModel()