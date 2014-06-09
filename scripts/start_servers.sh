#!/usr/bin/env bash

# START THE SERVERS

{

    # Trace mode

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # NGINX & PHP-FPM

    $dir/../nginx/setup/start-nginx.sh
    
    ~/.phpenv/versions/$(phpenv version-name)/sbin/php-fpm

    # Mongrel 2

    #$dir/../nginx/setup/start-mongrel2.sh
    
    # uWSGI

    #$dir/../nginx/setup/start-uwsgi.sh

}