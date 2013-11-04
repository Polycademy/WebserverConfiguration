# convert www to non-www redirect
server {

  # don't forget to tell on which port this server listens
  listen 80;
  listen [::]:80 ipv6only=on;
  listen 443 ssl;
  listen [::]:443 ipv6only=on;

  # listen on the www host
  server_name www.example.com;

  # and redirect to the non-www host (declared below)
  return 301 $scheme://example.com$request_uri;

}

server {
  
  #ipv4 and ipv6
  listen 80;
  listen [::]:80 ipv6only=on;
  listen 443 ssl;
  listen [::]:443 ipv6only=on;

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
  include conf.d/base.conf;

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
  # To prevent execution of non php files. We check if the $uri is there, and if so, return 404
  # PATH_INFO and PATH_TRANSLATED may not exist in the standard fastcgi_params
  location ~* \.php$ {
    try_files $uri =404;
    fastcgi_split_path_info (.+\.php)(.*)$;
    fastcgi_param PATH_INFO $fastcgi_path_info;
    fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
  }

}