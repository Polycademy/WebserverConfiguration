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

Test this one out for SSL settings: #add_header Strict-Transport-Security max-age=63072000;

3. Add SPDY support to NGINX http://nginx.org/en/docs/http/ngx_http_spdy_module.html (Will require custom build of NGINX and recent OpenSSL extension)

4. Add YAML content type to be gzipped/compressed. Also add it to Expires module as data. Could also add binary JSON too.

5. Because HTML templates are now precompiled and added to the js files, you do not need to actually add HTML to the expires module. HTML can still be considered data and hence browser cache required. This means your home page, or default HTML page is always loaded on request, but all subsequent HTML data will be cached along with the javascript file. This means if you change your original HTML layout, browsers will receive the changes immediately and this important if you major changes to your scripts. But your templates remain cached. It's a WIN - WIN!

6. https://gist.github.com/konklone/6532544 (advanced SSL and spdy support)