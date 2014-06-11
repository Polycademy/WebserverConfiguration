#!/usr/bin/env bash

{

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Reset the NGINX configuration directory

    sudo rm -rf /etc/nginx/*

    # Copy the NGINX configuration

    sudo cp -rf $dir/../configuration/* /etc/nginx/

}