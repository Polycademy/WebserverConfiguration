uWSGI
=====

uWSGI is a very interesting web server and protocol. It acts almost like PHP-FPM for PHP, but it works for WSGI in Python and Rack in Ruby and also in Perl. This means it can often work with NGINX or Haproxy in front.

https://github.com/unbit/uwsgi

The project is very active and its community seem to have a goal in making uWSGI work all platforms, languages, and web server integrations. Note that uWSGI can be used underneath Mongrel 2 or NGINX or Apache... etc. The usage of uWSGI with Mongrel 2 actually offsets Mongrel 2's disadvantage in their lackluster handler libraries. The uWSGI community instead provides handler libraries or integration methods that can be used inside Python, Ruby, Node, Go and PHP...

Refer to this: http://metz.gehn.net/2013/02/running-anything-on-nginx-with-uwsgi/