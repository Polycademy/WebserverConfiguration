Polycademy's MONGREL 2 Configuration
====================================

Mongrel 2 is a very unique web server/proxy/load balancer. To understand why it's so awesome, see this blog post: http://zef.me/4502/message-queue-based-load-balancing

Mongrel 2 is fully language agnostic, so there isn't seperate configuration styles for different languages. It does however require you to make your web applications use ZMQ has the transport protocol. This also means you cannot do any kind of CGI. Your web applications that are connected to Mongrel 2 need to be long running daemons. Now in the future, there might some kind of ZMQ to CGI proxy which can allow "CGI" scripts to get involved in the Mongrel 2 stack, but it kind of defeats the purpose of using Mongrel 2.

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