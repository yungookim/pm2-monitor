'use strict';

class pm2Monitor.Models.Pm2AppModel extends Backbone.Model

  urlRoot : '/test.json'

  defaults : 
    system_info:
      hostname: ""
      uptime: 0
    monit:
      # //  load average for the past 1, 5, and 15 minutes
      loadavg: [0, 0, 0]
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
      interfaces:
        lo: [
          address: "127.0.0.1"
          family: "IPv4"
          internal: true
        ,
          address: "::1"
          family: "IPv6"
          internal: true
        ]
        wlan0: [
          address: ""
          family: "IPv4"
          internal: false
        ,
          address: ""
          family: "IPv6"
          internal: false
        ]
    processes: [
      pid: 0
      opts:
        script: ""
        name: ""
        pm_exec_path: ""
        DBUS_SESSION_BUS_ADDRESS: ""
        pm_out_log_path: ""
        fileOutput: ""
        pm_err_log_path: ""
        fileError: ""
        pm_pid_path: ""
        pidFile: ""
        pm_id: 0
        pm_uptime: 0
        restart_time: 0
        unstable_restarts: 0
      pm_id: 0
      status: "online"
      monit:
        memory: 0
        cpu: 0
    ]

  initialize : ->
    @fetch
      success : (model, response, options)->
        console.log 'PM2 stats loaded'

      error : (model, response, options) ->
        console.log 'Error while loading PM2 stats'

