'use strict';

class presentation.Models.HostModel extends Backbone.Model

  urlRoot : '/api/local'

  defaults : 
    system_info:
      hostname: ""
      uptime: 0
    monit:
      loadavg: [0, 0, 0] # //  load average for the past 1, 5, and 15 minutes
      total_mem: 0
      free_mem: 0
      cpu: [
        model: ""
        speed: 0
        times:
          user: 0
          nice: 0
          sys: 0
          idle: 0
          irq: 0
      ]
    processes: [
      pid: 0
      pm_id: 0
      pm2_env : # Version < 6 has a different structure. i.e. opts
        name : ""
        env :
          USER : ""
        exec_mode : ""
        pm_exec_path : ""
        pm_out_log_path : ""
        pm_err_log_path : ""
        pm_id : 0
        restart_time : 0
        unstable_restarts : 0
        created_at : 0
        pm_uptime : 0
        status : ""
      monit:
        memory: 0
        cpu: 0
    ]

  initialize : (param)->
    if param and param.url
      param.url = param.url.replace /&#47;/g, '/'
      @urlRoot = '/api/remote'
      @set 'id', param.url

    @fetch
      success : (model, response, options)=>
        window.setInterval ()=>
          @fetch()
        , 5000
        

      error : (model, response, options) ->
        console.log response
        model.set 'errno', response
        console.log model
        console.log 'Error while loading PM2 stats'

  parse : (res, opt)->
    # TODO verify the units are correct
    _.each res.processes, (process)->
      process.monit.memory_consumption = process.monit.memory/res.monit.total_mem
      process.monit.memory_consumption_percent = (process.monit.memory_consumption * 100).toFixed 2
      process.monit.cpu_consumption_percent = (process.monit.cpu * 100).toFixed 4
    
    return res
