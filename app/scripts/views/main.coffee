'use strict';

class pm2Monitor.Views.MainView extends Backbone.View

  initialize : ->
    @template = window.JST['main-template']
    @listenTo @model, 'change', @render

  render : ->
    @$el.html Mustache.render @template, @model.toJSON()