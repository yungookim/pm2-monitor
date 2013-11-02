'use strict';

class pm2Monitor.Models.Pm2AppModel extends Backbone.Model

  urlRoot : '/api/server'

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

  initialize : ->
    @fetch
      success : (model, response, options)=>
        @get('system_info').uptime_hour = model.get('system_info').uptime%3600
        console.log 'PM2 stats loaded'

      error : (model, response, options) ->
        console.log 'Error while loading PM2 stats'