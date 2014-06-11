#!/usr/bin/env bash

# CONFIGURE THE SERVERS for TRAVIS

{

    # Trace mode

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    #########
    # NGINX #
    #########

    # Copy the NGINX Applications

    sudo mkdir -p /www && sudo cp -rf $dir/../servers/nginx/applications/* /www/

    # Enable NGINX Applications
    cd $dir/../servers/nginx/sites-enabled
    ln -fs ../sites-available/* .
    cd -

    # Configure NGINX's /etc/nginx directory

    $dir/../servers/nginx/setup/configure-nginx.sh

    # Configure PHP-FPM

    sudo cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf

    echo "cgi.fix_pathinfo = 1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

    #############
    # Mongrel 2 #
    #############

    #$dir/../servers/mongrel2/setup/configure-mongrel2.sh

}