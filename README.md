pm2-monitor
===========
  
Please note that this project is under heavy development and it's not ready for production environment. (A lot of things are still broken)
  
Web monitoring layer for [pm2](https://github.com/Unitech/pm2) web api

Requirements
============

* pm2 > 6.0 (v5.x has different data structure for its web API and is not supported by this project)    
* Coffeescript  

Running
=======
_Make sure pm2 and its monit api is running (```pm2 web```)_
```
git clone git@github.com:yungookim/pm2-monitor.git
cd pm2-monitor/server 
npm install
./run_production
```
Open up [http://localhost:8210/](http://localhost:8210/) on your browser.  
  
Adding Remote Servers/Clusters
==============================
  
Open pm2-monitor/server/config.json, add the URL of the remote to hosts : []  
  
Screenshot
==========
<img src="https://dl.dropboxusercontent.com/u/36220055/Screenshot%20from%202013-11-01%2015%3A32%3A36.png">

TODO  
  
* override Model.parser for graphical output  
* [*] Real-time pulling (TODO : Keep the scrolls intact after re-rendering)
* Persistant saving  
* [pm2-interface](https://github.com/Unitech/pm2-interface) integration for web client control  
* Change the pie graphs to something that can support re-rendering.
* Authentication
* Documentation

Other Projects Used/Referenced

* [sb-admin](https://github.com/IronSummitMedia/startbootstrap/tree/master/templates/sb-admin)  
