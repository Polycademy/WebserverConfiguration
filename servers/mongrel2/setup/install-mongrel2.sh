#!/usr/bin/env bash

{

    # Trace mode

    set -x

    # Exit if any command returned an error

    error() {
        echo "Error on line $1"
        exit 1
    }
    trap 'error $LINENO' ERR

    # Get the preferred versions

    while [[ $# > 1 ]]; do
        key="$1"
        shift
        case $key in
            -m|--mongrel2)
                mongrel2_version="$1"
                shift
            ;;
            -z|--zeromq)
                zeromq_version="$1"
                shift
            ;;
        esac
    done    

    # Install dependencies
    # 
    # * checkinstall: package the .deb

    apt-get install -y wget checkinstall dpkg build-essential sqlite3 libsqlite3-dev

}