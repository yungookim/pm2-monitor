'use strict';

class pm2Monitor.Views.MainView extends Backbone.View

  initialize : ->
    @template = window.JST['main-template']
    @listenTo @model, 'change', @render

  render : ->
    @$el.html Mustache.render @template, @model.toJSON()
    @render_graphs()

  render_graphs : ->

    # Load Average Indicators
    _.each $('.load_avg'), (each)->
      avg = parseFloat($(each).html())
      if avg < 0.7
        $(each).addClass 'label-success'
      else if avg > 0.7 and avg < 0.85
        $(each).addClass 'label-warning'
      else if avg > 0.85
        $(each).addClass 'label-danger'

    # Memory usage
    free_mem = @model.get('monit').free_mem
    free_mem_percent = (free_mem/@model.get('monit').total_mem).toFixed(2) * 100
    used_mem = @model.get('monit').total_mem - free_mem
    used_mem_percent = (used_mem/@model.get('monit').total_mem).toFixed(2) * 100

    Morris.Donut
      element: "memory_graph"
      data: [
        label: "Free"
        value: free_mem_percent
      ,
        label: "Used"
        value: used_mem_percent
      ]
      formatter : (y, data)->
        y + "%"

    # Load Average
    Morris.Bar
      element: "load_avg"
      data: [
        y: ""
        one :  @model.get('monit').loadavg[0].toFixed(2)
        five :  @model.get('monit').loadavg[1].toFixed(2)
        fifteen : @model.get('monit').loadavg[2].toFixed(2)
      ]
      xkey: "y"
      ykeys: ["one", "five", 'fifteen']
      labels: ["1-min", "5-min", "15-min"]
      # stacked : true
      # axes : false
      grid : false
