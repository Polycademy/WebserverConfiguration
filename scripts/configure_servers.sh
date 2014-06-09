#!/usr/bin/env bash

# CONFIGURE THE SERVERS

{

    # Trace mode

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # NGINX & PHP-FPM

    $dir/../servers/nginx/setup/configure-nginx.sh

    sudo cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf
    echo "cgi.fix_pathinfo = 1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

    # Mongrel 2

    #$dir/../servers/mongrel2/setup/configure-mongrel2.sh

    # uWSGI

    #$dir/../servers/uwsgi/setup/configure-uwsgi.sh

}