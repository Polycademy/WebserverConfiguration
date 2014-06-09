WebserverConfiguration
======================

Web server configuration for Apache, NGINX, Mongrel 2 and uWSGI, with automated tests. WIP.s

TODO:
----

1. NGINX WebSockets support http://siriux.net/2013/06/nginx-and-websockets/ (this is just a proxy form, we need to have separate file examples)
7. How to redirect any mention of index.php to non index.php routes. Such as http://e.com/index.php/blah to http://e.com/blah. To force an external rewrite, we have to do a redirect.
8. Add proxy and uwsgi styles to NGINX.
9. NGINX Cache Busting is not working. (rebuild NGINX from source)
10. Add automated Web Server tests.