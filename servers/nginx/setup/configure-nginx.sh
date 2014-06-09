#!/usr/bin/env bash

{

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Copy the NGINX configuration

    sudo cp -rf $dir/../configuration/* /etc/nginx/*

    # Copy the applications

    sudo mkdir -p /www
    sudo cp -rf $dir/../applications/* /www/*

}