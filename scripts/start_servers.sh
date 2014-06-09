#!/usr/bin/env bash

{

    # Trace mode

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # NGINX

    $dir/../nginx/setup/start-nginx.sh

    # Mongrel 2

    #$dir/../nginx/setup/start-mongrel2.sh
    
    # uWSGI

    #$dir/../nginx/setup/start-uwsgi.sh

}