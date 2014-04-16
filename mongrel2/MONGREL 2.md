Polycademy's MONGREL 2 Configuration
====================================

Mongrel 2 is a very unique web server/proxy/load balancer. To understand why it's so awesome, see this blog post: http://zef.me/4502/message-queue-based-load-balancing Mongrel 2 is designed for HTTP traffic, and it will not support any other protocols.

Mongrel 2 is fully language agnostic, so there isn't seperate configuration styles for different languages. It does however require you to make your web applications use ZMQ has the transport protocol. This also means you cannot do any kind of CGI. Your web applications that are connected to Mongrel 2 need to be long running daemons. Now in the future, there might some kind of ZMQ to CGI proxy which can allow "CGI" scripts to get involved in the Mongrel 2 stack, but it kind of defeats the purpose of using Mongrel 2.

Mongrel 2 will chroot to a particular directory and drop permissions to the user launching the process. This directory should be your application's root directory. All paths are relative from this directory. Your directory will need to have these folders created, without these, the process will not be created:

```
run/ (mongrel 2's pids will be here)
logs/ (access and error logs will be stored here)
uploads/ (if providing uploads)
certs/ (if providing SSL)
```

Each configuration will have to be customised for your specific project. Mainly because Mongrel 2 doesn't automatically serve static files, you need to configure it to serve files from a particular directory. When using Mongrel 2 it actually becomes quite prudent to put all your static files in just one folder which is separated from all the other files. This includes any images, CSS, and Javascript.

The conf file is loaded into m2sh to create a sqlite database. This is the database that Mongrel 2 runs from.

```sh
# Load the conf into sqlite db
m2sh load -db path/to/server.sqlite -config server.conf
# Show available servers
m2sh servers -db path/to/server.sqlite
# Show available hosts
m2sh hosts -db path/to/server.sqlite
# Start all servers
m2sh start -db path/to/server.sqlite -every -sudo
# Stop all servers
m2sh stop -db path/to/server.sqlite -every -murder
```

If you run m2sh where sqlite database exists at the working directory, you can omit the `-db path/to/server.sqlite` option.

SSL Configuration
-----------------

By default SSL configuration is disabled in the server.conf with the commented out sections. If you want to activate SSL, you need to create the certificate and key, their names must match the UUID of the Mongrel 2 server you're enabling SSL for. So if UUID of the server is "ssl_server", then the files must be `ssl_server.crt` and `ssl_server.key`.

For PHP
-------

While PHP is generally used in a CGI style. This includes FCGI and FPM. There are solutions to make PHP long running worker daemon!

* PHP-ZMQ https://github.com/mkoppanen/php-zmq
* m2php https://github.com/winks/m2php
* React http://reactphp.org/ & php-pm https://github.com/marcj/php-pm
* Photon http://www.photon-project.com/index.html
* AMP https://github.com/rdlowrey/Amp

For Javascript
--------------

* m2node https://github.com/dan-manges/m2node
* zeromq.node https://github.com/JustinTulloss/zeromq.node