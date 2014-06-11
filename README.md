WebserverConfiguration
======================

Web server configuration for Apache, NGINX, Mongrel 2 and uWSGI, with automated tests. WIP.

The project showcases various forms of optimised web server configuration. Useful for learning, testing, experimenting or adapting into your own current web server configuration.

More web servers will be added in the future.

Hopefully this can highlight the differences in web servers, and what they are good for.

Common architectures could be (in order of abstraction):

1. NGINX -> uWSGI -> Anything
2. NGINX -> Mongrel2 -> ZMQ -> Anything
3. Hipache -> NGINX -> Above
4. Apache Traffic Server -> Hipache -> NGINX -> Above
5. GSLB (DNS) -> Apache Traffic Server (CDN/Caching) -> Hipache (Dynamic Proxy) -> NGINX -> Above

Imagine for example that you run a big cluster. You have your GSLB for global load balancing. You have your Apache Traffic Server for CDN across data centers. Within a data center you might have a cluster of applications, which needs to dynamically balanced with Hipache. And within each application, they might use NGINX + whatever application runner they are using.

One important thing to understand is the difference between web servers designed to serve static content vs dynamic content.

Serving static content usually involves CDNs, Caching, Mirrors, Compression.. etc.

Serving dynamic content usually involves dynamic load balancing, CGI/FastCGI/uWSGI/FPM/ZMQ protocols and websockets.

This becomes a high availability/high performance exercise.

See this for more information: http://blog.elsdoerfer.name/2014/01/27/looking-for-a-12factor-app-reverse-proxy/

Testing
-------

The `./scripts` folder is designed for Travis testing. It's not useful for anything else.

TODO:
----

1. NGINX WebSockets support http://siriux.net/2013/06/nginx-and-websockets/ (this is just a proxy form, we need to have separate file examples)
7. How to redirect any mention of index.php to non index.php routes. Such as http://e.com/index.php/blah to http://e.com/blah. To force an external rewrite, we have to do a redirect.
8. Add proxy and uwsgi styles to NGINX.
9. NGINX Cache Busting is not working. (rebuild NGINX from source)
10. Add automated Web Server tests.

TODO use one of:

1. OpenResty
2. Tengine

Replace NGINX. We're going to have some crazy web server configurations.