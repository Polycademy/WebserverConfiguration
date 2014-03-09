WebserverConfiguration
======================

Web server configuration for Apache (via .htaccess) and NGINX.

Apache's .htaccess is a bit more flexible, however it is not as high performance as NGINX as Apache needs to read each .htaccess file.

NGINX also has the advantage of a much more elegant syntax, making it actually far easier to learn how to use.

These configuration files are based off the H5BP project, however they have been enhanced to be a bit more opinionated for Polycademy's usage.

TODO:

1. How to redirect any mention of index.php to non index.php routes. Such as http://e.com/index.php/blah to http://e.com/blah. To force an external rewrite, we have to do a redirect.

2. http://en.m.wikipedia.org/wiki/HTTP_Strict_Transport_Security

3. https://github.com/zendtech/ZendOptimizerPlus/issues/126#issuecomment-24020445 For Capistrano and Rocketeer and OpCode Cache

4. https://www.exratione.com/2014/03/running-nginx-as-a-non-root-user/ Non root user