#!/usr/bin/env bash

# INSTALL THE SSL CERTIFICATE AND KEY

{

    # Trace mode

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Generate SSL certificate and key pair for all the domains

    $dir/../bin/sslcreator "*.fastcgi.com" "*.proxypass.com" "*.websockets.com" "*.zmq.com" -f multidomain -b 2048

    # Copy into NGINX

    mkdir -p $dir/../servers/nginx/configuration/ssl
    cp multidomain.crt $dir/../servers/nginx/configuration/ssl/multidomain.crt
    cp multidomain.key $dir/../servers/nginx/configuration/ssl/multidomain.key

    # Copy into Mongrel 2
    
    #mkdir -p $dir/../servers/mongrel2/configuration/ssl
    #cp multidomain.crt $dir/../servers/mongrel2/configuration/ssl/multidomain.crt
    #cp multidomain.key $dir/../servers/mongrel2/configuration/ssl/multidomain.key

    # Copy into uWSGI

    #mkdir -p $dir/../servers/uwsgi/configuration/ssl
    #cp multidomain.crt $dir/../servers/uwsgi/configuration/ssl/multidomain.crt
    #cp multidomain.key $dir/../servers/uwsgi/configuration/ssl/multidomain.key

    # Collect garbage

    rm multidomain.crt
    rm multidomain.key

}