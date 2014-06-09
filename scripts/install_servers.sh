#!/usr/bin/env bash

# INSTALL THE SERVERS

{

    # Trace mode

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # NGINX

    $dir/../servers/nginx/setup/install-nginx.sh --nginx nginx-1.7.1 --openssl openssl-1.0.1h

    # Mongrel 2

    #$dir/../servers/mongrel2/setup/install-mongrel2.sh --mongrel2 v1.9.1 --zeromq zeromq-4.0.4

    # uWSGI

    #$dir/../servers/uwsgi/setup/install-uwsgi.sh --uwsgi 2.0.5.1

}