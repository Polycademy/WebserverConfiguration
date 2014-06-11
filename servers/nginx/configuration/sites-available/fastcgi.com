# FASTCGI.COM Example
# This example uses PHP (php-fpm), since it is the archetypical language that uses FastCGI

# Upstream server
upstream fastcgi_server {

    # multiple upstream servers should be either stateless or share sessions
    server 127.0.0.1:9000;

    # make sure the same client goes to the same server
    # this will not work for internal facing applications because not all of the IP is checked
    # this is only useful if you have sessions that are not shared between backends
    # if you do not need sessions, or that your sessions are shared, then this is not required
    # its highly recommended that you should be sharing your sessions!
    #ip_hash;

    # send connections to the least used upstream
    # either least_conn or ip_hash can be active, both cannot be simultaneously active
    least_conn;

    # backend keepalive connections limit, this number is dependent on your memory vs speed tradeoff
    # if you have many kept alive connections, this will consume memory, however you do not need to 
    # recreate TCP connections everytime to your backend unless you exhaust the number limit
    # however, this memory increase may not be justifiable if your upstream is local to NGINX
    # the overhead of TCP connections will much lower, but you'll still have the memory increase
    # this is more useful for clustered setups where upstream may be hosted remotely and when there
    # is a lot of requests. In terms of PHP, this number should be equal to the max children in FPM.
    # for now it's disabled because of this bug in PHP-FPM http://forum.nginx.org/read.php?2,235956,235956#msg-235956
    #keepalive 32;

}

# Convert www to non-www redirect 
server {

    # Listen parameters specific to system calls listen() and bind() cannot be duplicated
    listen 80;
    listen [::]:80;
    listen 443 ssl spdy;
    listen [::]:443 ssl spdy;

    # listen on the www host
    server_name www.fastcgi.com;

    # SSL Settings (get free certificates at StartSSL, GlobalSign or low cost ones at GetSSL)
    ssl_certificate      fastcgi.com.crt;
    ssl_certificate_key  fastcgi.com.key;
    # Chain of all certificates for OCSP stapling
    ssl_trusted_certificate fastcgi.com.crt;

    # HSTS and OCSP stapling on entry
    include conf.d/ssl.conf;

    # and redirect to the non-www host
    return 301 $scheme://fastcgi.com$request_uri;

}

# Production environment
server {

    # Listen parameters specific to system calls listen() and bind() cannot be duplicated
    # You can add `deferred` for Linux, `accept_filter=httpready` for FreeBSD during real production
    # But they can only be used for a single address:port combo, so make sure it's used for the most
    # important entry point!
    listen 80;
    listen [::]:80;
    listen 443 ssl spdy;
    listen [::]:443 ssl spdy;

    server_name fastcgi.com;

    root /www/fastcgi.com;

    # Force SSL, if you need to support tunnelled ports, switch to $http_host (but HTTP 1.0 may not have the HOST header)
    if ($ssl_protocol = "") {
        return 301 https://$server_name$request_uri;
    }

    # SSL Settings (get free certificates at StartSSL, GlobalSign or low cost ones at GetSSL)
    ssl_certificate      fastcgi.com.crt;
    ssl_certificate_key  fastcgi.com.key;
    # Chain of all certificates for OCSP stapling
    ssl_trusted_certificate fastcgi.com.crt;

    # Index search file to serve if in a directory
    index index.php index.html index.htm;

    #UTF-8 charset
    charset utf-8;

    # Include the recommended base config
    include conf.d/ssl.conf; 
    include conf.d/expires.conf;
    include conf.d/cache-busting.conf;
    include conf.d/x-ua-compatible.conf;
    include conf.d/protect-system-files.conf;
    include conf.d/cache-file-descriptors.conf;
    include conf.d/cross-domain-fonts.conf;
    include conf.d/cross-domain-ajax.conf;
    include conf.d/buffers.conf;
    include conf.d/no-transform.conf;

    # Removes the initial /index or /index.php
    if ($request_uri ~* ^(/index(.php)?)/?$) {
        rewrite ^(.*)$ / permanent;
    }

    # Removes trailing slashes from URIs that are not directories
    # example.com/controller/ -> example.com/controller
    if (!-d $request_filename) {
        rewrite ^/(.+)/$ /$1 permanent;
    }

    # Redirect all requests that are not going to a file or directory the front controller
    if (!-e $request_filename) {
        rewrite ^/(.*)$ /index.php?/$1 last;
    }

    # Fallback on front controller pattern if it cannot find files or directories matching the uri
    # Cascade onto the front controller pattern
    location / {
        try_files $uri $uri/ /index.php;
    }

    # Fast cgi to the PHP run time
    location ~* \.php$ {
        try_files $uri =404;
        include fastcgi_params;
        fastcgi_pass fastcgi_server;
        fastcgi_index index.php;
        fastcgi_intercept_errors on;
        fastcgi_hide_header x-powered-by;
        fastcgi_keep_conn on;
        fastcgi_next_upstream error timeout;
    }

}

# Development environment
server {

    # Listen parameters specific to system calls listen() and bind() cannot be duplicated
    listen 80;
    listen [::]:80;
    listen 443 ssl spdy;
    listen [::]:443 ssl spdy;

    # The host name to respond to, map only the dev hostname to ip address on dev server
    server_name dev.fastcgi.com;

    # Path for static files
    root /www/fastcgi.com;

    # Force SSL, we use $http_host as it can potentially contain the client's tunnelled port, which is often used in VMs for development
    if ($ssl_protocol = "") {
        return 301 https://$http_host$request_uri;
    }

    # SSL settings
    # Development SSL certificate must support 'dev' or wildcard subdomains
    ssl_certificate         fastcgi.com.crt;
    ssl_certificate_key     fastcgi.com.key;

    # HSTS (this makes sure that the client is using HTTPS, even for subdomains)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";

    # Index search file to serve if in a directory
    index index.php index.html index.htm;

    #UTF-8 charset
    charset utf-8;

    # Include the recommended base config
    include conf.d/expires.conf;
    include conf.d/cache-busting.conf;
    include conf.d/x-ua-compatible.conf;
    include conf.d/protect-system-files.conf;
    include conf.d/cross-domain-fonts.conf;
    include conf.d/cross-domain-ajax.conf;
    include conf.d/buffers.conf;
    include conf.d/no-transform.conf;

    # Removes the initial /index or /index.php
    if ($request_uri ~* ^(/index(.php)?)/?$) {
        rewrite ^(.*)$ / permanent;
    }

    # Removes trailing slashes from URIs that are not directories
    # example.com/controller/ -> example.com/controller
    if (!-d $request_filename) {
        rewrite ^/(.+)/$ /$1 permanent;
    }

    # Redirect all requests that are not going to a file or directory the front controller
    if (!-e $request_filename) {
        rewrite ^/(.*)$ /index.php?/$1 last;
    }

    # Fallback on front controller pattern if it cannot find files or directories matching the uri
    # Cascade onto the front controller pattern
    location / {
        try_files $uri $uri/ /index.php;
    }

    # Fast cgi to the PHP run time
    location ~* \.php$ {
        try_files $uri =404;
        include fastcgi_params;
        fastcgi_pass fastcgi_server;
        fastcgi_index index.php;
        fastcgi_intercept_errors on;
        fastcgi_hide_header x-powered-by;
        fastcgi_keep_conn on;
        fastcgi_next_upstream error timeout;
    }

}