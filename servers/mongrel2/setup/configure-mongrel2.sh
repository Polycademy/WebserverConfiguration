#!/usr/bin/env bash

{

    set -x

    # Current directory

    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Create the project

    sudo mkdir -p /www
    sudo cp -rf $dir/../applications/* /www/*

    # Mongrel 2 configuration exists in the same place as the application
    # All ssl certificates and keys need to match the UUID of the https_server

    for apps in /www/*; do
        sudo cp -rf "$dir/../configuration/*" "$apps/*"
        sudo mv "$apps/ssl/*.key" "$apps/ssl/0c9cb0c0-c55e-11e3-9c1a-0800200c9a66.key"
        sudo mv "$apps/ssl/*.crt" "$apps/ssl/0c9cb0c0-c55e-11e3-9c1a-0800200c9a66.crt"
    done

}