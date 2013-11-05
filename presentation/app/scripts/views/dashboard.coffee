'use strict';

class presentation.Views.DashboardView extends Backbone.View

  initialize : ->
  
    @template = window.JST['dashboard-template']
    @$el.html @template
    @listenTo @collection, 'change', @render

  render : ->
    console.log 'rendering DashboardView'
    $('#table_wrapper').empty()
    _.each @collection.models, (model)->
      $('#table_wrapper').append Mustache.render $('#subtemplate_daemon').html(), hosts : model.toJSON()