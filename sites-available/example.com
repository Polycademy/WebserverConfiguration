# convert www to non-www redirect
server {

  listen 80;
  listen [::]:80;
  listen 443 ssl;
  listen [::]:443 ssl;

  # listen on the www host
  server_name www.example.com;

  # and redirect to the non-www host (declared below)
  return 301 $scheme://example.com$request_uri;

}

server {
  
  #ipv4 and ipv6
  listen 80;
  listen [::]:80;
  listen 443 ssl;
  listen [::]:443 ssl;

  # Accessible from http://example.com, this will require mapping hostname to ip address on dev server
  # Also specifies all subdomains
  server_name example.com *.example.com;

  # Path for static files
  root /www/example.com/;

  # Index search file to serve if in a directory
  # Example uses php
  index index.php index.html index.htm;

  #Specify a charset
  charset utf-8;

  # Custom error pages, this should be handled on the app layer
  # error_page 404 /404.html;
  # error_page 500 502 503 504 /50x.html;

  # Include the recommended base config
  include conf.d/expires.conf;
  include conf.d/cache-busting.conf;
  include conf.d/x-ua-compatible.conf;
  include conf.d/protect-system-files.conf;
  include conf.d/cache-file-descriptors.conf;
  include conf.d/cross-domain-fonts.conf;
  include conf.d/cross-domain-ajax.conf;
  # Uncomment this to prevent mobile network providers from modifying your site 
  # include conf.d/no-transform.conf;

  # Force ssl
  # if ($ssl_protocol = "") {
  #   return 301 https://example.com$request_uri;
  # }

  # Removes the initial index or index.php
  # Changes example.com/index.php to example.com/
  # Changes example.com/index to example.com/
  if ($request_uri ~* ^(/index(.php)?)/?$) {
    rewrite ^(.*)$ / permanent;
  }

  # Removes the index method of every controller
  # Changes example.com/controller/index to example.com/lol
  # Changes example.com/controller/index/ to example.com/lol
  if ($request_uri ~* index/?$) {
    rewrite ^/(.*)/index/?$ /$1 permanent;
  }

  # Removes any trailing slashes from uris that are not directories
  # Changes example.com/controller/ to example.com/controller
  # Thus normalising the uris
  if (!-d $request_filename) {
    rewrite ^/(.+)/$ /$1 permanent;
  }

  # Send all requests that are not going to a file, directory or symlink to front controllers
  if (!-e $request_filename) {
    rewrite ^/(.*)$ /index.php?/$1 last;
  }

  # Try to get the file, or directory and fallback on the front controller pattern
  location / {
    try_files $uri $uri/ /index.php?$args;
  }

  # This example uses PHP
  # PATH_INFO may not exist in the standard fastcgi_params
  # Make sure PHP-FPM is listening via a Unix Domain Socket at /var/run/php5-fpm.sock
  location ~* \.php$ {
    # Prevent uploaded file execution exploit
    # This won't work if the uploaded files are on a different server
    # Comment the try_files if the php-fpm is on another machine
    # https://nealpoole.com/blog/2011/04/setting-up-php-fastcgi-and-nginx-dont-trust-the-tutorials-check-your-configuration/
    try_files $uri =404;
    fastcgi_split_path_info (.+\.php)(.*)$;
    fastcgi_param PATH_INFO $fastcgi_path_info;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    fastcgi_intercept_errors on;
  }

}