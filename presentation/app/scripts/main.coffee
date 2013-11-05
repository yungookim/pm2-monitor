window.presentation =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    'use strict'
    new @Routers.MainRouter()
    Backbone.history.start()

$ ->
  'use strict'
  presentation.init();
