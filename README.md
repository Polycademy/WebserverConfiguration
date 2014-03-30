WebserverConfiguration
======================

Web server configuration for Apache (via .htaccess) and NGINX.

Apache's .htaccess is a bit more flexible, however it is not as high performance as NGINX as Apache needs to read each .htaccess file.

NGINX also has the advantage of a much more elegant syntax, making it actually far easier to learn how to use.

These configuration files are based off the H5BP project, however they have been enhanced to be a bit more opinionated for Polycademy's usage.

The NGINX files are updated more often than Apache.

TODO:

1. How to redirect any mention of index.php to non index.php routes. Such as http://e.com/index.php/blah to http://e.com/blah. To force an external rewrite, we have to do a redirect.

2. http://en.m.wikipedia.org/wiki/HTTP_Strict_Transport_Security

3. https://github.com/zendtech/ZendOptimizerPlus/issues/126#issuecomment-24020445 For Capistrano and Rocketeer and OpCode Cache

4. https://www.exratione.com/2014/03/running-nginx-as-a-non-root-user/ Non root user

5. Test this one out for SSL settings: #add_header Strict-Transport-Security max-age=63072000;

6. Add SPDY support to NGINX http://nginx.org/en/docs/http/ngx_http_spdy_module.html (Will require custom build of NGINX and recent OpenSSL extension)

7. Add YAML content type to be gzipped/compressed. Also add it to Expires module as data. Could also add binary JSON too.

8. https://gist.github.com/konklone/6532544 (advanced SSL and spdy support)

9. Replace default unix domain socket with TCP socket with an upstream component. It's far better! And it's more flexible for the purposes of load balancing. It allows greater scalability, portability and everything. Also works well with exposing via Docker containers if you need to containerise NGINX.