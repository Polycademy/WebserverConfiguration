WebserverConfiguration
======================

Web server configuration for Apache (via .htaccess), NGINX and Mongrel 2.

Apache's .htaccess is a bit more flexible, however it is not as high performance as NGINX as Apache needs to read each .htaccess file. NGINX has the advantage of a much more elegant syntax, making it actually far easier to learn how to use. Mongrel 2 is probably the most interesting, use it for high scalability and high availability SOA that uses ZMQ as an internal communication protocol.

These configuration files are based off the H5BP project, however they have been enhanced to be a bit more opinionated for Polycademy's usage.

The NGINX and Mongrel 2 files are updated more often than Apache.

TODO:
----

1. NGINX WebSockets support http://siriux.net/2013/06/nginx-and-websockets/
2. NGINX SPDY support http://nginx.org/en/docs/http/ngx_http_spdy_module.html & https://gist.github.com/konklone/6532544
3. HSTS Support http://en.m.wikipedia.org/wiki/HTTP_Strict_Transport_Security & Test this one out for SSL settings: #add_header Strict-Transport-Security max-age=63072000;
4. Opcode Cache Issue (Capistrano + Rocketeer) https://github.com/zendtech/ZendOptimizerPlus/issues/126#issuecomment-24020445
5. NGINX non-root user https://www.exratione.com/2014/03/running-nginx-as-a-non-root-user/
6. Add YAML content type to be gzipped/compressed. Also add it to Expires module as data. Could also add binary JSON too.
7. How to redirect any mention of index.php to non index.php routes. Such as http://e.com/index.php/blah to http://e.com/blah. To force an external rewrite, we have to do a redirect.