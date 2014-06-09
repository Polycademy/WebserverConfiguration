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
            -n|--nginx)
                nginx_version="$1"
                shift
            ;;
            -o|--openssl)
                openssl_version="$1"
                shift
            ;;
        esac
    done

    # Install dependencies
    # 
    # * checkinstall & dpkg: package the .deb
    # * libpcre3, libpcre3-dev: required for HTTP rewrite module
    # * zlib1g zlib1g-dbg zlib1g-dev: required for HTTP gzip module

    apt-get install -y wget git unzip checkinstall dpkg build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dbg zlib1g-dev

    # Source repositories

    mkdir -p ~/sources
    cd ~/sources

    # Get NGINX mainline

    wget "http://nginx.org/download/${nginx_version}.tar.gz"
    tar zxf "${nginx_version}.tar.gz"

    # Get OpenSSL

    wget "http://www.openssl.org/source/${openssl_version}.tar.gz"
    tar -xzvf "${openssl_version}.tar.gz"

    # Configure nginx.
    #
    # With these additional flags:
    # * --with-debug: adds helpful logs for debugging
    # * --with-openssl: compile against newer version of open ssl
    # * --with-http_spdy_module: include the SPDY module
    $nginx_version/configure --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=www-data \
    --group=www-data \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-http_spdy_module \
    --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-z,relro -Wl,--as-needed' \
    --with-ipv6 \
    --with-debug \
    --with-openssl=$HOME/sources/$openssl_version

    # Make the package.
    $nginx_version/make

    # Create a .deb package

    $nginx_version/checkinstall --install=no -y && \

    # Install the package

    dpkg -i $nginx_version/$nginx_version-1_amd64.deb

}