'use strict';

class pm2Monitor.Views.DashboardView extends Backbone.View

  initialize : ->
  
    @template = window.JST['main-template']
    @listenTo @model, 'change', @render_soft
    @render()

    # window.setInterval( ()=>
    #   console.log 'fetching...'
    #   @model.fetch
    #     success : (model, response, options)=>
    #       console.log response
    #       console.log 'PM2 stats loaded'

    #     error : (model, response, options) ->
    #       alert response
    #       console.log 'Error while loading PM2 stats'
    # , 10000)

  render : ->
    @$el.html Mustache.render @template, @model.toJSON()

    # Notify that the data is not available
    if @model.get 'errno'
      $('#err_msg').parent().parent().removeClass 'hide'
      $('#err_msg').html @model.get 'errno'
    else 
      @render_graphs()

  render_soft : ->
    @render_graphs()

  render_graphs : ->
    @load_avg_indicators()
    @memory_graph()
    @load_avg_graphs()
    @cpu_graphs()
    @process_tables()

  load_avg_indicators : ->
    # Load Average Indicators, TODO STUPID way. fix this later
    _.each $('.load_avg'), (each)->
      avg = parseFloat($(each).html())
      if avg < 0.7
        $(each).addClass 'label-success'
      else if avg > 0.7 and avg < 0.85
        $(each).addClass 'label-warning'
      else if avg > 0.85
        $(each).addClass 'label-danger'

  memory_graph : ->
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

  load_avg_graphs : ->
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

  cpu_graphs : ->
    _template = window.JST['cpu-template']
    $('#cpu_details').html Mustache.render _template, @model.toJSON()
    # CPU
    processors = @model.get('monit').cpu
    _.each processors, (p) =>
      # Calculate the percentages
      total = p.times.user + p.times.nice + p.times.sys + p.times.idle
      user = (p.times.user/total * 100).toFixed(2)
      nice = (p.times.nice/total* 100).toFixed(2)
      system = (p.times.sys/total* 100).toFixed(2)
      idle = (p.times.idle/total * 100).toFixed(2)
      # Save the total CPU for later use
      p.times.total = total

      # Create a random id for DOM element to contain the graph
      _id = (Math.random() / + new Date()).toString(36).replace(/[^a-z]+/g, '')
      wrapper = $('<div/>').addClass 'col-lg-6'
      _dom = $('<div/>').attr('id', _id)
      wrapper.html _dom
      $('#cpu_graphs').append wrapper

      Morris.Donut
        element: _id
        data: [
          label: "user"
          value: user
        ,
          label: "nice"
          value: nice
        ,
          label: "system"
          value: system
        ,
          label: "idle"
          value: idle 
        ]
        formatter : (y, data)->
          y + "%"

  process_tables : ()->
    $table = $ '#process_table'
    _template = window.JST['process-template']
    $table.html Mustache.render _template, @model.toJSON()
